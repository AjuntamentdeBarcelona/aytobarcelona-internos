# frozen_string_literal: true

# extends the title size to 250 characters
Rails.application.configure do
  config.after_initialize do
    Decidim::Proposals::ProposalForm
      .validators_on(:title).find { |v| v.is_a?(ProposalLengthValidator) }
      .instance_variable_set(:@options, { minimum: 15, maximum: 250 })
    Decidim.available_locales.each do |locale|
      Decidim::Proposals::Admin::ProposalForm
        .validators_on(:"title_#{locale}").find { |v| v.is_a?(ProposalLengthValidator) }
        .instance_variable_set(:@options, { minimum: 15, maximum: 250 })
    end
  end
end
