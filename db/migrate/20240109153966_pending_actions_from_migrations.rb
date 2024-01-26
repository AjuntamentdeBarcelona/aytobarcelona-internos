# frozen_string_literal: true

class PendingActionsFromMigrations < ActiveRecord::Migration[5.2]
  def change
    Decidim::Comments::Comment.reset_column_information
    Decidim::Comments::Comment.find_each(&:update_comments_count)
    Decidim::Meetings::Meeting.reset_column_information
    Decidim::Meetings::Meeting.find_each(&:update_comments_count)
    Decidim::Proposals::Proposal.reset_column_information
    Decidim::Proposals::Proposal.find_each(&:update_comments_count)
    Decidim::Proposals::CollaborativeDraft.reset_column_information
    Decidim::Proposals::CollaborativeDraft.find_each(&:update_comments_count)
  end
end
