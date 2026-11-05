# frozen_string_literal: true

module Decidim
  # Lists likes chronologically (oldest first) instead of by author.
  # Backport of decidim/decidim#17792.
  module LikeOverride
    extend ActiveSupport::Concern

    included do
      scope :for_listing, -> { order(:created_at, :id) }
    end
  end
end
