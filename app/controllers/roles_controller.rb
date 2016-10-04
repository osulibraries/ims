class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy, :add_user, :remove_user]
  load_and_authorize_resource
  
  respond_to :html

  def index
    @roles = Role.all
    respond_with(@roles)
  end

  def show
    respond_with(@role)
  end

  def new
    @role = Role.new
    respond_with(@role)
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    flash[:notice] = 'Role was successfully created.' if @role.save
    redirect_to roles_path
  end

  def update
    flash[:notice] = 'Role was successfully updated.' if @role.update(role_params)
    redirect_to roles_path
  end

  def destroy
    @role.destroy
    respond_with(@role)
  end

  def add_user
    change_role(@role)
  end

  def remove_user
    change_role(nil)
  end




  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end

    def change_role(role)
      u = find_user
      if u
        u.role = role
        u.save!
        redirect_to edit_role_path(@role), :flash => {:success => "Successfully updated the user's Role."}
      else
        redirect_to edit_role_path(@role), :flash=> {:error=>"Unable to find the user #{params[:user_key]}"}
      end
    end

    def find_user
      ::User.send("find_by_#{find_column}".to_sym, params[:user_key])
    end

    def find_column
      Devise.authentication_keys.first
    end

   
end
