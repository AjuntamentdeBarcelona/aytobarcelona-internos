# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/test/factories"

module Decidim
  describe EndorsersListCell, type: :cell do
    controller Decidim::PagesController

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, organization: organization) }
    let(:other_user) { create(:user, :confirmed, nickname: "test_user", organization: organization) }
    let(:participatory_space) { create(:participatory_process, organization: organization) }
    let(:component) { create(:proposal_component, participatory_space: participatory_space) }
    let(:proposal) { create(:proposal, component: component) }
    let!(:endorsement) { create(:endorsement, resource: proposal, author: other_user) }

    context "when rendering the endorsers list modal" do
      subject { cell("decidim/endorsers_list", proposal, layout: :full).call }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:current_organization).and_return(organization)
      end

      it "displays the user nickname in the title attribute" do
        expect(subject).to have_css("div[title='@test_user']")
      end
    end
  end
end
