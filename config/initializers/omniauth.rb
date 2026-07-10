# frozen_string_literal: true

OmniAuth.config.allowed_request_methods = [:post, :get]

if Decidim::Env.new("OMNIAUTH_KEYCLOAK_CLIENT_ID").present?
  class OmniAuth::Strategies::KeycloakOpenId
    info do
      {
        nickname: raw_info["user"],
        name: raw_info["givenName"],
        email: raw_info["email"]
      }
    end
  end

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :keycloak_openid,
             ENV.fetch("OMNIAUTH_KEYCLOAK_CLIENT_ID", nil),
             ENV.fetch("OMNIAUTH_KEYCLOAK_CLIENT_SECRET", nil),
             client_options: {
               site: ENV.fetch("OMNIAUTH_KEYCLOAK_SITE", nil),
               realm: ENV.fetch("OMNIAUTH_KEYCLOAK_REALM", nil)
             }
  end

  Rails.application.config.to_prepare do
    Devise::OmniauthCallbacksController.class_eval do
      skip_before_action :verify_authenticity_token

      before_action :verify_user_type, only: :keycloakopenid

      def verify_user_type
        unless valid_user?(request.env["omniauth.auth"])
          flash[:error] = I18n.t("devise.failure.invalid_user_type")
          redirect_to root_path
        end
      end

      private

      def valid_user?(response)
        valid_admin?(response.dig("extra", "raw_info", "user")) || valid_type?(response.dig("extra", "raw_info", "tipusUsuari"))
      end

      def valid_type?(type_list)
        return false unless type_list

        type_list = [type_list] if type_list.is_a?(String)
        type_list.any? { |type| type.in?(Decidim::Env.new("OMNIAUTH_USER_TYPES", "T1,T2,T3,T11").to_array) }
      end

      # Check if the user is in the list of allowed admin users
      def valid_admin?(user)
        return false unless user

        user.in?(Decidim::Env.new("OMNIAUTH_KEYCLOAK_ADMIN_IDS").to_array)
      end
    end
  end

  Decidim.omniauth_providers = Decidim.omniauth_providers.merge(keycloakopenid: { enabled: true })
end

OmniAuth.config.logger = Rails.logger
