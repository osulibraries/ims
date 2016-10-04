class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter do
    can_user_socialize?
    resource = controller_path.singularize.gsub('/', '_').to_sym 
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller  
# Adds Sufia behaviors into the application controller 
  include Sufia::Controller

  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  layout 'sufia-one-column'
  # layout 'application'
  # @full_width_body = true

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper Openseadragon::OpenseadragonHelper



  def can_user_socialize?
    if (params[:controller].match(/my\//)).present? || params[:controller] == "dashboard" || params[:controller] == "users"
      unless current_user.is_member
        raise CanCan::AccessDenied, "You must be granted permission before you are allowed to access this feature."
      end
    end
  end

end
