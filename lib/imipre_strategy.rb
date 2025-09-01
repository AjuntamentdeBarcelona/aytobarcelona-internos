# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"

module OmniAuth
  module Strategies
    # Omniauth client for Imipre
    class Imipre < OmniAuth::Strategies::OAuth2
      option :name, :imipre
      option :client_id, Rails.application.secrets.dig(:omniauth, :imipre, :client_id)
      option :client_secret, Rails.application.secrets.dig(:omniauth, :imipre, :client_secret)
      option :site, Rails.application.secrets.dig(:omniauth, :imipre, :site_url)
      option :client_options, {}
      option :redirect_uri, Rails.application.secrets.dig(:omniauth, :imipre, :redirect_uri)

      def authorize_params
        super.tap do |params|
          params[:scope] = Rails.application.secrets.dig(:omniauth, :imipre, :scope)
        end
      end

      def build_access_token
        options.token_params.merge!(headers: { "X-OAUTH-IDENTITY-DOMAIN-NAME": Rails.application.secrets.dig(:omniauth, :imipre, :domain) })
        super
      end

      uid do
        Employee.find_by!(code: raw_info["sub"])
        raw_info["sub"]
      end

      # TODO: Check raw info content for user type
      info do
        employee = Employee.find_by!(code: raw_info["sub"])
        if employee.present?
          {
            email: employee.email,
            name: "#{employee.name} #{employee.surnames}"
          }
        else
          false
        end
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = authorize_url
        options.client_options[:token_url] = token_url
        super
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get(Rails.application.secrets.dig(:omniauth, :imipre, :info_url),
                                       { headers: { "X-OAUTH-IDENTITY-DOMAIN-NAME": Rails.application.secrets.dig(:omniauth, :imipre, :domain) } }).parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end

      private

      def authorize_url
        @authorize_url ||= URI.join(
          options.site,
          "/oauth2/rest/authz?response_type=code" \
          "&client_id=#{options.client_id}" \
          "&domain=#{Rails.application.secrets.dig(:omniauth, :imipre, :domain)}" \
          "&scope=#{Rails.application.secrets.dig(:omniauth, :imipre, :scope)}" \
          "&redirect_uri=#{Rails.application.secrets.dig(:omniauth, :imipre, :redirect_uri)}"
        ).to_s
      end

      def token_url
        @token_url ||= URI.join(
          options.site,
          "/oauth2/rest/token?grant_type=AUTHORIZATION_CODE&code="
        ).to_s
      end
    end
  end
end
