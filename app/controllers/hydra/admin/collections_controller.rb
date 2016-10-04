class Hydra::Admin::CollectionsController < ApplicationController
  load_and_authorize_resource class: 'Hydra::Admin::Collection'

# This is from the hydra-collections gem.
  include Hydra::Collections::AcceptsBatches
  include Hydra::CollectionsControllerBehavior

  layout 'sufia-one-column'


  def index
    @collections = current_user.admin_sets
    respond_to do |format|
      format.html { render :layout => 'sufia-one-column' }
    end
  end

  def create
    @collection = Hydra::Admin::Collection.new(collection_params)
    @admin_policy = Osul::AdminPolicy.create!
    @collection.admin_policy = @admin_policy

    setup_permissions
    if @collection.save
      # default_permissions
      update_policy_permissions
      redirect_to hydra_admin_collections_path, notice: "The #{t('admin_set_name')} was successfully created."
    else
      render :new
    end
  end

  def edit
    @collection.depositor = current_user.user_key
  end

  def new
    @collection.depositor = current_user.user_key
  end

  def show
    query_collection_members
    presenter
  end

  def destroy
    if @collection.destroy
      respond_to do |format|
        format.html { redirect_to hydra_admin_collections_path, notice: "#{t('admin_set_name')} was successfully deleted." }
      end
    end
  end

  def update
    notice = "#{t('admin_set_name')} was successfully updated."
    @collection = Hydra::Admin::Collection.find(params[:id])
    
    setup_permissions
    @collection.attributes = collection_params
    queue_member_update = @collection.unit_changed? || @collection.visibility_change_is_restrictive?
    
    if @collection.save
      update_policy_permissions
      if queue_member_update
        notice += " Since the changes you made impact the items in this collection, all members are being updated in a background job."
        Sufia.queue.push(UpdateMembers.new( @collection.id ))
      end
      redirect_to hydra_admin_collections_path, notice: notice
    else
      render 'edit'
    end
  end



  def add_members
    @collection = Hydra::Admin::Collection.find(params[:id])
    add_members_to_collection @collection
  end

  def get_admin_set_permissions
    @admin_set = Hydra::Admin::Collection.find(params[:id])
    render :json => @admin_set.permissions.to_json
  end


  def presenter
      @presenter ||= presenter_class.new(@collection)
  end
  def presenter_class
    Sufia::AdminSetPresenter
  end
  
  def calculate_admin_set_stats
    collection = Hydra::Admin::Collection.find(params[:id])
    count = "N/A" #collection.members.count
    bytes = "N/A" #collection.bytes
    render :json => {total_members: count, total_bytes: bytes.to_s(:human_size)}
  end


  protected

    def presenter_class
      Sufia::AdminSetPresenter
    end
    
    # TODO: Move this to the backend
    def default_permissions
      # @collection.apply_depositor_metadata(@collection.depositor)
      @collection.set_edit_users([current_user.user_key], [])
      @collection.set_edit_groups(["admin"], [])
    end

    # since we're reusing the generic_file permissions partial we need to move generic_file params to hydra_admin_collection params
    # Add groups and users we want added to every new admin set collection
    def setup_permissions
      # merge_permissions_attributes
      merge_visibility
    end

    # I know this is super-hacky, but... Sorry.
    def merge_permissions_attributes
      if params[:hydra_admin_collection][:permissions_attributes]
        if params[:generic_file]
          params[:generic_file][:permissions_attributes].each do |k, v|
            if params[:hydra_admin_collection][:permissions_attributes][k].present?
              params[:hydra_admin_collection][:permissions_attributes][k].merge!(v)
            else  
              params[:hydra_admin_collection][:permissions_attributes][k] = v
            end
          end  
        end 
      else
        params[:hydra_admin_collection][:permissions_attributes] = params.try(:[], "generic_file").try(:[], "permissions_attributes")
      end

    end

    def merge_visibility
      params[:hydra_admin_collection][:visibility] = params[:visibility]
    end

    def update_policy_permissions
      @admin_policy ||= @collection.admin_policy
      merge_permissions_attributes
      unless admin_policy_params[:permissions_attributes].nil?
        @admin_policy.default_permissions_attributes = admin_policy_params[:permissions_attributes]
      end
      @admin_policy.save
    end


  # Snagged this method from hydra-collections gem Hydra::CollectionsControllerBehavior
    def add_members_to_collection collection = nil
      collection ||= @collection
      batch.each do |b| 
        member = GenericFile.find(b)
        member.collection_id = collection.id
        member.save
      end
      redirect_to hydra_admin_collection_path(@collection.id)
    end

    # Queries Solr for members of the collection.
    # Populates @response and @member_docs similar to Blacklight Catalog#index populating @response and @documents
    def query_collection_members
      flash[:notice]=nil if flash[:notice] == "Select something first"
      params[:cq] = {"isMemberOfCollection_ssim" => ["#{@collection.id}"]}
      super
    end

    def collection_member_search_builder_class
      ::SearchBuilder
    end

    def collection_member_search_logic
      search_params_logic + [:add_access_controls_to_solr_params]
    end

    def collection_params
      params.require(:hydra_admin_collection).permit(:title, :description, :visibility,
          :unit, creator: [], publisher: [], language: [])
      # If Admin Set should ever need it's own permissions again: , { permissions_attributes: [:access, :type, :name, :id, :_destroy] }
    end
    def admin_policy_params
      params.require(:hydra_admin_collection).permit({ permissions_attributes: [:access, :type, :name, :id, :_destroy] })
    end
end