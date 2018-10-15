class ApplicationController < ActionController::Base
  include VerifierConcern
  include Webhooks

  MOBILES = /Android|Windows Phone|Mobile|webOS|iPhone|BlackBerry|IEMobile|Opera Mini/

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  before_action :check_rack_mini_profiler
  before_action :detect_browser
  before_action :remove_subdomain_if_not_artist_page

  def current_user
    @current_user ||= User.find_by!(auth_token: cookies[:auth_token])
  rescue ActiveRecord::RecordNotFound
    reset_session
  end
  helper_method :current_user

  def authenticated?
    cookies[:auth_token] && current_user
  end
  helper_method :authenticated?

  def admin_authenticated?
    authenticated? && session[:admin]
  end
  helper_method :admin_authenticated?

  def authenticate!
    redirect_to root_path, notice: t('notice.must_login') unless authenticated?
  end

  def require_admin
    true if current_admin
  end

  def current_admin
    session[:admin]
  end

  def check_rack_mini_profiler
    Rack::MiniProfiler.authorize_request if params[:rmp].present?
  end

  def page_not_found
    respond_to do |format|
      format.html { render file: 'public/404.html', status: :not_found, layout: false }
      format.all  { render nothing: true, status: 404 }
    end
  end

  private

  def remove_subdomain_if_not_artist_page
    return true if request.subdomains.first == ENV['HEROKU_APP_NAME']
    redirect_to request.url.sub("#{request.subdomains.first}.", '') if subdomain_and_not_artist_page?
  end

  def subdomain_and_not_artist_page?
    request.subdomain.present? && request.subdomain != 'www' && params[:controller] != 'artist_subdomains'
  end

  def detect_browser
    request.variant = request.user_agent =~ MOBILES ? :mobile : :desktop
  end
end
