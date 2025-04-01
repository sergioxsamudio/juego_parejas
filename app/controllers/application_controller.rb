class ApplicationController < ActionController::Base
  before_action :set_locale
  skip_before_action :set_locale, only: :change

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
  def after_sign_in_path_for(resource)
    games_path(locale: I18n.locale)
  end

  def change
    locale = params[:locale]
    if I18n.available_locales.map(&:to_s).include?(locale)
      session[:locale] = locale
    end
    # Redirige a la página anterior o a la raíz, incluyendo el locale en la URL.
    redirect_back(fallback_location: root_path(locale: session[:locale]))
  end

  private

  def admin_controller?
    controller_path.start_with?("admin/")
  end
end

