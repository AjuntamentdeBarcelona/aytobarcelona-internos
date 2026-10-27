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
      "/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb" => "84cfe6c174fa96805cb210c6c4509e77",
      "/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb" => "43852a21a6aca14404c2959bb70bdb19",
      "/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb" => "a0c4ae48b1372ea5d37aae0112c9c826",
      "/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb" => "3ec70469c2d3dfbdb18fe22342e8fdfd"
    }
  },
  {
    package: "decidim-core",
    files: {
      # Deface footer override to add feder logo
      "/app/views/layouts/decidim/footer/_main.html.erb" => "31e54040476b6b748f1f61b21451149a",
      # Deface footer override to add the Barcelona institutional footer band (logo-negre)
      "/app/views/layouts/decidim/footer/_mini.html.erb" => "c67cc97db27cdcf926f60682e399f688",
      # Deface header override to add the Barcelona institutional brand-bar (logo + values banner)
      "/app/views/layouts/decidim/header/_main.html.erb" => "2808459045fd14b7f8d689fbbd6dfa4e",
      "/app/cells/decidim/likers_list/full.erb" => "dd10ba2333541afc7e5ca8694d678222",
      # OfficialAuthorPresenterOverride patches #avatar_url onto this presenter to show the Barcelona official avatar
      "/app/presenters/decidim/official_author_presenter.rb" => "dbfb2fefa1c75d703e65443cd68014c2",
      # CreateOmniauthRegistrationOverride normalizes (strip + downcase) the verified_email before the user lookup
      "/app/commands/decidim/create_omniauth_registration.rb" => "9c76a3012fffc7fec10ae3fe44046525"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      # Update proposal title size
      "/app/forms/decidim/proposals/admin/proposal_form.rb" => "5c6cc25fddd1964b2027eb92536268dd",
      "/app/forms/decidim/proposals/proposal_form.rb" => "fb1b26c23bf3d0dbe59ad02509e6445a"
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
