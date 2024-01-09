# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = 'Decidim Ajuntament de Barcelona'
  config.mailer_sender = 'svc_decidim@bcn.cat'

  # Change these lines to set your preferred locales
  config.default_locale = :ca
  config.available_locales = %i[ca]

  # Geocoder configuration
  if Rails.application.secrets.maps
    config.maps = {
      provider: :here,
      api_key: Rails.application.secrets.maps[:api_key],
      static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
    }
    config.geocoder = {
      timeout: 5,
      units: :km
    }
  end

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, component|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  config.currency_unit = '€'

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This component also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = false
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
