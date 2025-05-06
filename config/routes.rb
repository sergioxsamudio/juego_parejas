Rails.application.routes.draw do
  scope "(:locale)", locale: /es|en/ do
    devise_for :admins

    root 'games#enter_code'

    resources :games do
      resources :players, only: [:new, :create, :index] # Players dentro de Games (podría no ser necesario si solo actualizas score)
      collection do
        get 'enter_code'
        post 'verify_code'
      end
      member do
        get :start
        get 'register_players'
        post 'save_players'
        get 'play'
        post 'finish_game'
        get 'finish'
        get :export_players
        delete :purge_logo
      end
    end

    resources :players, only: [] do # Define rutas directamente para Players
      member do
        patch 'update_score'
      end
    end
  end

  # Cambio de idioma
  get "/locale/:locale", to: "application#change", as: :change_locale
end


