# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Decidim::Env.new("OMNIAUTH_KEYCLOAK_CLIENT_ID").present?
    keycloak_redirect = redirect { |_path_params, req| "/users/auth/keycloakopenid?#{req.query_parameters.to_query}" }
    locale_constraint = { locale: Regexp.union(I18n.available_locales.map(&:to_s)) }

    get "/users/sign_in", to: keycloak_redirect, as: :new_user_session
    get "/users/sign_up", to: keycloak_redirect, as: :new_user_registration
    # Decidim 0.32 serves the Devise pages under /:locale/
    get "/:locale/users/sign_in", to: keycloak_redirect, constraints: locale_constraint
    get "/:locale/users/sign_up", to: keycloak_redirect, constraints: locale_constraint
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
