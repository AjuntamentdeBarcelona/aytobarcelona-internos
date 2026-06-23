# frozen_string_literal: true

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
Rails.application.configure do
  config.after_initialize do
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
end
