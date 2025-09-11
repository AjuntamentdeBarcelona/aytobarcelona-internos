# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-direct_verifications",
    files: {
      # The only change for controllers is the full namespace for the parent class as it didn't resolved it well when it
      # was just ApplicationController
      "/app/controllers/decidim/direct_verifications/verification/admin/authorizations_controller.rb" => "5b713aa72da2ba5e4f0fefa840816004",
      "/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb" => "dfe29d5353030989c07866d37b794157",
      "/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb" => "43852a21a6aca14404c2959bb70bdb19",
      "/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb" => "a0c4ae48b1372ea5d37aae0112c9c826",
      "/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb" => "705d2ef9a0c33ad68899b28c4b1dc42d"
    }
  },
  {
    package: "decidim-core",
    files: {
      # Deface footer override to add feder logo
      "/app/views/layouts/decidim/footer/_main.html.erb" => "b22323d9508fa8a14bd669d665a04634"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      # Update proposal title size
      "/app/forms/decidim/proposals/admin/proposal_form.rb" => "34e42ec6c9911b60c28d2bb49f066a8c",
      "/app/forms/decidim/proposals/proposal_form.rb" => "8db839481fec2a53acecabbf22377aa6"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
