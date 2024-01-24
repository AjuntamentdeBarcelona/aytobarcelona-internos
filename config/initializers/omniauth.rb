# frozen_string_literal: true

if Rails.application.secrets.dig(:omniauth, :imipre, :enabled)
  module OmniAuth
    module Strategies
      # tell OmniAuth to load our strategy
      autoload :Imipre, Rails.root.join("lib/imipre_strategy")
    end
  end
end

Rails.logger.info "SAML ENABLED? #{Rails.application.secrets.dig(:omniauth, :saml, :enabled)}"
if Rails.application.secrets.dig(:omniauth, :saml, :enabled)
  Devise.setup do |config|
    config.omniauth :saml,
                    idp_cert: Rails.application.secrets.dig(:omniauth, :saml, :idp_cert),
                    idp_sso_target_url: Rails.application.secrets.dig(:omniauth, :saml, :idp_sso_target_url),
                    sp_entity_id: Rails.application.secrets.dig(:omniauth, :saml, :sp_entity_id),
                    strategy_class: ::OmniAuth::Strategies::SAML,
                    attribute_statements: {
                      email: ["mail"],
                      name: %w(givenName nom)
                    },
                    certificate: Rails.application.secrets.dig(:omniauth, :saml, :certificate),
                    private_key: Rails.application.secrets.dig(:omniauth, :saml, :private_key),
                    security: {
                      authn_requests_signed: true,
                      signature_method: XMLSecurity::Document::RSA_SHA256
                    }
  end

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
      acl_list.any? { |acl| /cn=#{Rails.application.secrets.dig(:omniauth, :saml, :cn)}(,|\b)/i.match? acl }
    end

    def valid_type?(type_list)
      type_list.any? { |type| type.in? Rails.application.secrets.dig(:omniauth, :saml, :user_types) }
    end
  end

  # Decidim::User.omniauth_providers << :saml
end

OmniAuth.config.logger = Rails.logger
