class Osul::GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource class: 'Osul::Group'

  # GET /groups
  # GET /groups.json
  def index
    get_groups

    respond_to do |format|
      format.html { render :layout => 'sufia-one-column' }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    respond_to do |format|
      format.html { render :layout => 'sufia-one-column' }
    end
  end

  # GET /groups/new
  def new
    @group = Osul::Group.new
    get_units_for_select
  end

  # GET /groups/1/edit
  def edit
    get_units_for_select
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Osul::Group.new(group_params)
    get_units_for_select

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        unless params[:new_user].blank?
          user = User.find(params[:new_user].to_i)
          @group.users << user  unless @group.users.include? user
          user.update_user_group_list
        end
       
        format.html { redirect_to edit_osul_group_path(@group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_users
    @group = Osul::Group.find(params[:id])
    params[:user_ids].each do |id|
      group_user = Osul::GroupUser.where(:user_id => id, :group_id => params[:id])
      @group.group_users.delete(group_user)
      User.find(id).update_user_group_list
    end
    redirect_to edit_osul_group_path(@group), notice: 'Users were successfully removed.'

  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to osul_groups_path, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Osul::Group.find(params[:id])
    end

    def get_units_for_select
      @units = current_user.units.collect{|unit| [unit.name, unit.id] }
    end

    def get_groups
      if current_user.admin?
        @groups = Osul::Group.all
      else
        @groups = current_user.units
        current_user.units.each{ |unit| @groups += unit.groups }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:osul_group).permit(:name, :description, :contact_info, :is_unit, :unit_id, :user_ids)
    end
end
