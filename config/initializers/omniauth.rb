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
        valid_cn?(response.dig("extra", "raw_info", "cn")) || valid_type?(response.dig("extra", "raw_info", "tipusUsuari"))
      end

      # ACL starting with `cn=ACCES` mean that the user is an admin.
      # The user should be allowed whatever its type.
      def valid_cn?(acl_list)
        return false unless acl_list

        # Sometimes we receive "ACCES" and some times "ACCESS" so we use
        # a regexp with the shorter one.
        acl_list = [acl_list] if acl_list.is_a?(String)
        acl_list.any? { |acl| /cn=#{Rails.application.secrets.dig(:omniauth, :keycloakopenid, :cn)}(,|\b)/i.match?(acl) }
      end

      def valid_type?(type_list)
        return false unless type_list

        type_list = [type_list] if type_list.is_a?(String)
        type_list.any? { |type| type.in?(Rails.application.secrets.dig(:omniauth, :keycloakopenid, :user_types).split(",")) }
      end
    end
  end
end

OmniAuth.config.logger = Rails.logger
