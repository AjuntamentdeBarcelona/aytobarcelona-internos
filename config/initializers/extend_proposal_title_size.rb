# extends the title size to 250 characters
Rails.application.configure do
  config.after_initialize do
   Decidim::Proposals::ProposalWizardCreateStepForm
   .validators_on(:title).find{|v|v.is_a?(ActiveModel::Validations::LengthValidator)}
   .instance_variable_set(:@options, {maximum:250})
   Decidim::Proposals::Admin::ProposalForm
   .validators_on(:title).find{|v|v.is_a?(ActiveModel::Validations::LengthValidator)}
   .instance_variable_set(:@options, {maximum:250})
  end
end
