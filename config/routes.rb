# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  if Rails.application.secrets.dig(:omniauth, :keycloakopenid, :enabled)
    get "/users/sign_in", to: redirect { |_path_params, req| "/users/auth/keycloakopenid?#{req.params.to_query}" }, as: :new_user_session
    get "/users/sign_up", to: redirect { |_path_params, req| "/users/auth/keycloakopenid?#{req.params.to_query}" }, as: :new_user_registration
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
