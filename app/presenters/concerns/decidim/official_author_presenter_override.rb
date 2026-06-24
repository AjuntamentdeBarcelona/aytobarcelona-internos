# frozen_string_literal: true

module Decidim
  # Makes official authors (resources authored by the organization itself, not
  # by a participant) display the Ajuntament de Barcelona avatar instead of the
  # generic Decidim default one.
  #
  # The method is defined inside `included do` so it lands on the including class
  # itself, taking precedence over the `avatar_url` that core defines directly on
  # `Decidim::OfficialAuthorPresenter`. Since every module subclass
  # (`Decidim::Proposals::OfficialAuthorPresenter`, `Blogs::...`, etc.) inherits
  # from that base class, they all pick up the override.
  module OfficialAuthorPresenterOverride
    extend ActiveSupport::Concern

    included do
      def avatar_url(_variant = nil)
        ActionController::Base.helpers.asset_pack_path("media/images/official-avatar.png")
      end
    end
  end
end
