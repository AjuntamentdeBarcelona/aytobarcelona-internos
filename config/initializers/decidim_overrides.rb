# frozen_string_literal: true

# Runtime overrides applied to Decidim core/modules.
#
# Everything lives in a single `to_prepare` block so the patches are re-applied
# on every code reload in development (and once on boot in production). This
# block is registered after the engines' own `to_prepare` blocks — notably
# decidim-decidim_awesome's, which re-adds the proposal title validator we tweak
# below — so by the time this runs those classes are fully set up.
Rails.application.config.to_prepare do
  # Gives official authors a custom Ajuntament de Barcelona avatar.
  #
  # Ported from the public decidim-barcelona site
  # (AjuntamentdeBarcelona/decidim-barcelona#745). Unlike that repo, internos does
  # not define a `Decidim::DeletedAuthorPresenter`, and in Decidim 0.31.5 deleted
  # users are presented through `Decidim::UserPresenter` (not the official author
  # presenter), so this override only needs to touch `OfficialAuthorPresenter`.
  #
  # NOTE: if the "Overridden files" checksum spec for
  # `decidim/official_author_presenter.rb` fails after a Decidim upgrade, re-check
  # how `avatar_url` is resolved and update the override accordingly.
  Decidim::OfficialAuthorPresenter.include(Decidim::OfficialAuthorPresenterOverride)

  # Downcases/strips the SAML-verified email before the user lookup so people
  # whose IdP `mail` attribute has uppercase letters can log in and get their
  # identity linked, instead of failing with "Another account is using the same
  # email address".
  #
  # NOTE: if the "Overridden files" checksum spec for
  # `decidim/create_omniauth_registration.rb` fails after a Decidim upgrade,
  # re-check how `verified_email` is used and update the override accordingly.
  Decidim::CreateOmniauthRegistration.prepend(Decidim::CreateOmniauthRegistrationOverride)

  # Extends the proposal title size to 250 characters.
  #
  # At runtime the title length is validated by a `ProposalLengthValidator`: even
  # though decidim-proposals core validates it with a plain Rails length validator
  # (`length: { in: 15..150 }`), decidim-decidim_awesome clears that validator and
  # re-adds the title validation as `proposal_length: { ..., maximum: 150 }` on both
  # the public (:title) and admin (:title_#{locale}) forms. We locate that validator
  # and bump its maximum to 250.
  #
  # NOTE: if the "Overridden files" checksum spec for the proposals forms fails after
  # a decidim/decidim_awesome upgrade, re-check how the title length is validated and
  # update this patch accordingly.
  extend_title_length = lambda do |form, attribute|
    validator = form
                .validators_on(attribute)
                .find { |v| v.is_a?(ProposalLengthValidator) }
    next unless validator

    validator.instance_variable_set(:@options, validator.options.merge(maximum: 250))
  end

  extend_title_length.call(Decidim::Proposals::ProposalForm, :title)

  Decidim.available_locales.each do |locale|
    extend_title_length.call(Decidim::Proposals::Admin::ProposalForm, :"title_#{locale}")
  end
end
