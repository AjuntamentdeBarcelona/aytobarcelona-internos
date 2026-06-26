# frozen_string_literal: true

Decidim::Verifications.register_workflow(:direct_verifications_group1) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group2) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group3) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group4) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group5) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group6) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group7) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group8) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::Verifications.register_workflow(:direct_verifications_group9) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

Decidim::DirectVerifications.configure do |config|
  config.manage_workflows = %w(direct_verifications direct_verifications_group1 direct_verifications_group2 direct_verifications_group3 direct_verifications_group4
                               direct_verifications_group5 direct_verifications_group6 direct_verifications_group7 direct_verifications_group8 direct_verifications_group9)
end
