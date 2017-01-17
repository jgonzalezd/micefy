class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, except: :user_password

  before_filter :set_locale, :except => [:set_locale_manually]

  def set_locale_manually
    session[:return_to] ||= request.referer
    locale = params[:locale]
    if (locale.present?  && (['es','en'].include? locale))
        session[:locale] = locale
    end
    redirect_to session.delete(:return_to)
  end

  protected

    def after_sign_in_path_for(resource)
      case resource
      when Organizer
        organizers_events_path
      when User
        dashboard_path
      when Admin
        rails_admin_path
      else
        root_path
      end
    end

    def devise_parameter_sanitizer
      case
      when resource_class == User
        User::ParameterSanitizer.new(User, :user, params)
      when resource_class == Organizer
        Organizer::ParameterSanitizer.new(Organizer, :organizer, params)
      else
        super # Use the default one
      end
    end

  private
    def extract_locale_from_accept_language_header
      http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      if['es','en'].include? http_accept_language
        http_accept_language
      else
        I18n.locale
      end
    end

    def set_locale
      session[:locale] = extract_locale_from_accept_language_header || I18n.default_locale unless session[:locale].present?
      I18n.locale = session[:locale]
    end
end
