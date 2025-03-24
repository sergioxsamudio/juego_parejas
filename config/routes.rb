Rails.application.routes.draw do
  scope "(:locale)", locale: /es|en/ do
    resources :players
    resources :images
    resources :games
    devise_for :admins

    root 'games#enter_code'
    
    resources :games, only: [:show] do
      collection do
        get 'enter_code'
        post 'verify_code'
      end
      member do
        get 'register_players'
        post 'save_players'
      end
    end

    resources :players, only: [:create]
  end

  # Si mantienes change en ApplicationController
  get "/locale/:locale", to: "application#change", as: :change_locale
end





