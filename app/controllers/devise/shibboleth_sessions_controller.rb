class Devise::ShibbolethSessionsController < Devise::SessionsController
  require 'cgi'
  require 'uri'

  before_action :set_user, only: [:auth]
  before_action :update_user_info, only: :auth

  def new
    session[:users_return_to] = request.referrer != nil && request.referrer.include?(root_url) ? request.referrer : sufia.dashboard_index_path
    if params[:auth] == 'shibboleth'# || request.env['HTTP_EPPN'].present?
      url = [request.protocol,
             request.host,
             '/Shibboleth.sso/Login?target=',
             shib_auth_url,
             CGI.escape("?redirect=#{session[:users_return_to]}")].join
      redirect_to url
    else
      flash[:alert] = 'If you are currently OSU Faculty, Staff, or Student, please click the <strong><span class="glyphicon glyphicon-log-in" aria-hidden="true"></span> OSU Login</strong> button to auto-register or log in.'
      super
    end
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to session[:users_return_to]
  end

  def auth
    sign_in @user
    if @user.is_member
      redirect_to session[:users_return_to] || URI.decode(params[:redirect])
    else
      redirect_to root_url
    end
  end

  private

  def set_user
    @user = User.find_or_create_by email: request.env['HTTP_EPPN']
    @user.update({password: Devise.friendly_token, currently_osu: true})
  end

  def update_user_info
    first_name = request.env['HTTP_FIRST_NAME']
    last_name = request.env['HTTP_LAST_NAME']
    @user.display_name = "#{first_name} #{last_name}"
    @user.save!
  end

  def requested_url
    if request.respond_to? :url
      request.url
    else
      request.protocol + request.host + request.request_uri
    end
  end
end
