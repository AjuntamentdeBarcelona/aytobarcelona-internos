# frozen_string_literal: true

OmniAuth.config.allowed_request_methods = [:post, :get]

if Rails.application.secrets.dig(:omniauth, :keycloakopenid, :enabled)
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
             Rails.application.secrets.dig(:omniauth, :keycloakopenid, :client_id),
             Rails.application.secrets.dig(:omniauth, :keycloakopenid, :client_secret),
             client_options: {
               site: Rails.application.secrets.dig(:omniauth, :keycloakopenid, :site),
               realm: Rails.application.secrets.dig(:omniauth, :keycloakopenid, :realm)
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
        type_list.any? { |type| type.in?(Rails.application.secrets.dig(:omniauth, :keycloakopenid, :user_types).split(",")) }
      end

      # Check if the user is in the list of allowed admin users
      def valid_admin?(user)
        return false unless user

        user.in?(Rails.application.secrets.dig(:omniauth, :keycloakopenid, :admin_ids).split(","))
      end
    end
  end
end

OmniAuth.config.logger = Rails.logger
