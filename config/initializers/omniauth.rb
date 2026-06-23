# frozen_string_literal: true

OmniAuth.config.allowed_request_methods = [:post, :get]

saml_enabled = Decidim::Env.new("SAML_ENABLED").present?
Rails.logger.info "SAML ENABLED? #{saml_enabled}"
if saml_enabled
  Devise.setup do |config|
    config.omniauth :saml,
                    idp_cert: ENV.fetch("SAML_IDP_CERT", nil),
                    idp_sso_target_url: ENV.fetch("SAML_IDP_SSO_TARGET_URL", nil),
                    sp_entity_id: ENV.fetch("SAML_SP_ENTITY_ID", nil),
                    strategy_class: (ENV["SAML_STRATEGY_CLASS"].presence || "OmniAuth::Strategies::SAML").constantize,
                    attribute_statements: {
                      email: %w(mail),
                      name: %w(givenName nom)
                    },
                    certificate: ENV.fetch("SAML_CERTIFICATE", nil),
                    private_key: ENV.fetch("SAML_PRIVATE_KEY", nil),
                    security: {
                      authn_requests_signed: Decidim::Env.new("SAML_SECURITY_AUTHN_REQUESTS_SIGNED", "true").present?,
                      signature_method: ENV["SAML_SECURITY_SIGNATURE_METHOD"].presence || XMLSecurity::Document::RSA_SHA256
                    }
  end

  Rails.application.config.to_prepare do
    Devise::OmniauthCallbacksController.class_eval do
      skip_before_action :verify_authenticity_token

      before_action :verify_user_type, only: :saml

      def verify_user_type
        saml_response = OneLogin::RubySaml::Response.new(params["SAMLResponse"])
        unless valid_user?(saml_response)
          flash[:error] = I18n.t("devise.failure.invalid_user_type")
          redirect_to root_path
        end
      end

      private

      def valid_user?(response)
        valid_cn?(response.attributes.multi(:ACL)) || valid_type?(response.attributes.multi(:tipusUsuari))
      end

      # ACL starting with `cn=ACCES` mean that the user is an admin.
      # The user should be allowed whatever its type.
      def valid_cn?(acl_list)
        # Sometimes we receive "ACCES" and some times "ACCESS" so we use
        # a regexp with the shorter one.
        acl_list.any? { |acl| /cn=#{Decidim::Env.new("SAML_CN", "ACCES")}(,|\b)/i.match? acl }
      end

      def valid_type?(type_list)
        user_types = Decidim::Env.new("SAML_USER_TYPES", "T1,T2,T3,T11").to_array
        type_list.any? { |type| type.in?(user_types) }
      end
    end
  end

  # Decidim::User.omniauth_providers << :saml
end

OmniAuth.config.logger = Rails.logger
