# frozen_string_literal: true
# This migration comes from decidim_proposals (originally 20200827154156)

class AddCommentableCounterCacheToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_proposals, :comments_count, :integer, null: false, default: 0, index: true
    add_column :decidim_proposals_collaborative_drafts, :comments_count, :integer, null: false, default: 0, index: true
  end
end
