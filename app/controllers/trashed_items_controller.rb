class TrashedItemsController < ApplicationController
  load_and_authorize_resource except: [:create, :destroy]
  before_action :set_trashed_item, only: [:show, :edit, :update, :destroy]

  respond_to :html
  layout 'sufia-dashboard'

  def index
    @trashed_items = TrashedItem.all.order created_at: :desc
    #respond_with @trashed_items
    respond_to do |format|
      format.html { render :layout => 'sufia-dashboard' }
    end
  end

  def show
    respond_with @trashed_item
  end

  def new
    @trashed_item = TrashedItem.new
    respond_with @trashed_item
  end

  def edit
  end

  def bulk_trash_items
    files = params[:batch_document_ids]
    redirect_to return_to, notice: 'No files selected' if files.blank?

    files.each do |file|
      gf = GenericFile.find file
      gf.set_edit_users ['batchuser@example.com'], []
      TrashedItem.create depositor: gf.depositor, generic_file_id: gf.id, visibility: gf.visibility, collection_id: gf.collection_id
      gf.update depositor: 'batchuser@example.com', visibility: 'restricted', collection_id: nil
    end

    redirect_to sufia.dashboard_files_path, notice: "Successfully moved to the trash."
  end

  def create
    gf = GenericFile.find params[:file]
    redirect_to sufia.dashboard_files_path, notice: 'Unable to find file.' if gf.blank?
    @trashed_item = TrashedItem.new
    @trashed_item.collection_id = gf.collection_id
    @trashed_item.visibility = gf.visibility
    @trashed_item.depositor = gf.depositor
    @trashed_item.generic_file_id = gf.id
    gf.set_edit_users ['batchuser@example.com'], []
    gf.update depositor: 'batchuser@example.com', visibility: 'restricted', collection_id: nil
    redirect_to sufia.dashboard_files_path, notice: 'Successfully moved to the trash' if @trashed_item.save
  end

  def update
    flash[:notice] = 'TrashedItem was successfully updated.' if @trashed_item.update trashed_item_params
    respond_with @trashed_item
  end

  def destroy
    raise CanCan::AccessDenied unless can? :destroy, TrashedItem

    if params[:id].to_i == 0
      action = params[:trash_action]
      trashed_items = TrashedItem.where generic_file_id: params[:generic_file_ids]
      trashed_items.each { |ti| ti.send action.to_sym }
      redirect_to trashed_items_path, notice: "Files have been #{action}d successfully"
    else
      @trashed_item.restore if @trashed_item.destroy
      flash[:notice] = 'File has been restored successfully'
      respond_with @trashed_item
    end
  end

  private
    def set_trashed_item
      @trashed_item = TrashedItem.find params[:id] unless params[:id].to_i == 0
    end

    def trashed_item_params
      params.require(:trashed_item).permit :generic_file_id, :depositor
    end
end
