class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  private

  def set_locale
    locale = current_user.try(:locale) ||
             params[:user_locale] ||
             session[:locale] ||
             http_accept_compatible_locale

    session[:locale] = I18n.locale = locale_available?(locale) ? locale : I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def http_accept_compatible_locale
    http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def locale_available?(locale)
    return unless locale
    I18n.available_locales.include? locale.to_sym
  end
end
