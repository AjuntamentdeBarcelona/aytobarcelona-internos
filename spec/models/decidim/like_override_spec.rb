# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/test/factories"

# Adapted from decidim/decidim#17792 (spec/models/decidim/like_spec.rb)
describe Decidim::Like do
  describe ".for_listing" do
    let(:organization) { create(:organization) }
    let(:participatory_space) { create(:participatory_process, organization:) }
    let(:component) { create(:proposal_component, participatory_space:) }
    let(:resource) { create(:proposal, component:) }
    let(:other_resource) { create(:proposal, component:) }
    let!(:author) { create(:user, :confirmed, organization:) }
    let!(:other_author) { create(:user, :confirmed, organization:) }
    let!(:last_like) { create(:like, resource:, author:, created_at: 1.day.ago) }
    let!(:first_like) { create(:like, resource:, author: other_author, created_at: 3.days.ago) }
    let!(:middle_like) { create(:like, resource: other_resource, author:, created_at: 2.days.ago) }

    it "sorts likes by created_at regardless of the author" do
      expect(described_class.for_listing.pluck(:id)).to eq([first_like.id, middle_like.id, last_like.id])
    end

    context "when likes have the same created_at" do
      let(:tied_at) { 4.days.ago }
      let(:tied_author) { create(:user, :confirmed, organization:) }
      # Inserted in reverse id order so the tiebreaker, not the insertion order, decides
      let!(:tied_like_with_higher_id) do
        create(:like, id: described_class.maximum(:id) + 2, resource: other_resource, author: other_author, created_at: tied_at)
      end
      let!(:tied_like_with_lower_id) do
        create(:like, id: tied_like_with_higher_id.id - 1, resource: other_resource, author: tied_author, created_at: tied_at)
      end

      it "sorts them by id" do
        expect(described_class.where(created_at: tied_at).for_listing.pluck(:id)).to eq([tied_like_with_lower_id.id, tied_like_with_higher_id.id])
      end
    end
  end
end
