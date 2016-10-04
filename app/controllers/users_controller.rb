class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

    def user_params
      params.require(:user).permit(:avatar, :facebook_handle, :twitter_handle,
                                   :googleplus_handle, :linkedin_handle, :remove_avatar, :orcid)
    end
end