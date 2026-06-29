# frozen_string_literal: true

require "rails_helper"

describe Decidim::OfficialAuthorPresenter do
  let(:expected_path) { ActionController::Base.helpers.asset_pack_path("media/images/official-avatar.png") }

  describe "#avatar_url" do
    it "returns the Barcelona official avatar path" do
      expect(subject.avatar_url).to eq(expected_path)
    end

    it "ignores the variant argument" do
      expect(subject.avatar_url(:thumb)).to eq(expected_path)
    end
  end

  describe "subclass inheritance" do
    it "applies to Decidim::Proposals::OfficialAuthorPresenter" do
      expect(Decidim::Proposals::OfficialAuthorPresenter.new.avatar_url).to eq(expected_path)
    end

    it "applies to Decidim::Blogs::OfficialAuthorPresenter" do
      expect(Decidim::Blogs::OfficialAuthorPresenter.new.avatar_url).to eq(expected_path)
    end

    it "applies to Decidim::Meetings::OfficialAuthorPresenter" do
      expect(Decidim::Meetings::OfficialAuthorPresenter.new.avatar_url).to eq(expected_path)
    end

    it "applies to Decidim::Debates::OfficialAuthorPresenter" do
      expect(Decidim::Debates::OfficialAuthorPresenter.new.avatar_url).to eq(expected_path)
    end
  end
end
