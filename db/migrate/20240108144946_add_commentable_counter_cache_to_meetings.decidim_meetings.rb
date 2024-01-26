# frozen_string_literal: true
# This migration comes from decidim_meetings (originally 20200827153856)

class AddCommentableCounterCacheToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :comments_count, :integer, null: false, default: 0
  end
end
