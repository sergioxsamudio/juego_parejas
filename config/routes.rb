Rails.application.routes.draw do
  scope "(:locale)", locale: /es|en/ do
    devise_for :admins

    root 'games#enter_code'

    resources :games do
      resources :players, only: [:new, :create]
      
      collection do
        get 'enter_code'
        post 'verify_code'
      end

      member do
        get 'register_players'
        post 'save_players'
        get 'play'        
        get 'finish'
      end
    end
  end

  # Cambio de idioma
  get "/locale/:locale", to: "application#change", as: :change_locale
end


