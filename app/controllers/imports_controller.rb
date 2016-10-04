class ImportsController < ApplicationController
  load_and_authorize_resource

  before_action :admin_collection_list, only: [:new, :create, :edit, :update]
  before_action :visibility_levels, only: [:new, :create, :edit, :update]


  # GET /imports
  # GET /imports.json
  def index
    @imports = @imports.order(created_at: :desc).page(params[:page])
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
    num_of_previews =  10
    @preview_objects = @import.preview_import_from_csv(num_of_previews)
  end

  # GET /imports/1/row-preview/1
  def row_preview
    num_of_previews =  1
    @row_num = @import.includes_headers? ? params[:row_num].to_i - 2 : params[:row_num].to_i - 1
    @preview_objects = @import.preview_import_from_csv(num_of_previews, @row_num )
  end

  # Preview an image that is being imported by streaming it from the filesystem
  def image_preview
    path = @import.image_path_from_csv_row(params[:row].to_i)

    if File.file? path
      send_file path, :disposition => 'inline'
    else
      send_file File.join(Rails.root,'app','assets','images','no-file.png'), :type => 'image/png', :disposition => 'inline'
    end
  end

  # GET /imports/new
  def new
  end

  # GET /imports/1/edit
  def edit
    @field_mappings = @import.import_field_mappings
  end

  # POST /imports/1/start
  def start
    BatchImportService.new(@import, current_user).schedule
    redirect_to @import, notice: 'The import has started and will continue in the background. Check this page to see the progress of your import.'
  end

  # GET /imports/1/report
  def report
  end

  def resume
    BatchImportService.new(@import, current_user).resume
    redirect_to @import, notice: 'The import has resumed.'
  end

  def browse
    root = ENV['FEDORA_NFS_UPLOAD_PATH']
    @dir = URI.unescape(params[:dir])
    path = root + "/" + @dir

    # Change to requested directory
    Dir.chdir(File.expand_path(path).untaint);
    
    # Make sure we are still under the root path
    if Dir.pwd[0,root.length] == root then
      @directories = Dir.glob('*').select { |fn| File.directory?(fn) }
      render layout: false
    else
      # If someone requests a path outside of the browser root...
      render status: :forbidden, text: "Forbidden: You do not have permission to view the requested path"
    end
  end

  # POST /imports/1/undo
  def undo
    BatchImportService.new(@import, current_user).undo
    redirect_to @import, notice: 'All records created by this import will be removed shortly.'
  end

  def finalize
    BatchImportService.new(@import, current_user).finalize
    redirect_to @import, success: 'Import has been finalized. It can no longer be reverted.'
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_params)
    @import.user_id = current_user.id
    respond_to do |format|
      if @import.save
        ImportFieldMapping::KEYS.each do |key|
          ImportFieldMapping.create key: key, import: @import
        end
        #create mapping for image filename separately
        ImportFieldMapping.create key: 'image_filename', import: @import

        format.html { redirect_to edit_import_path(@import), notice: 'Import was successfully created. Use the form below to create metadata field mappings.' }
        format.json { render :show, status: :created, location: @import }
      else
        format.html { render :new }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|

     # params[:import][:import_field_mappings_attributes].map[]
      #byebug
      if @import.update(import_params)

        @import.validate_import_mappings if @import.is_editable?

        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { render :show, status: :ok, location: @import }
      else
        format.html { render :edit }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: 'Import was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

    def admin_collection_list
      @admin_collection_list = current_user.admin_sets.map{ |i| [i.title + ' - '+  i.unit, i.id ]}
    end

    def visibility_levels
      @visibility_levels = {
        'Private' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE,
        "#{t('sufia.institution_name')}" => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
        "#{t('sufia.visibility.open')}" => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      permitted_params = params.require(:import).permit(:user_id, :csv, :images, :name, :admin_collection_id, :includes_headers,
                                     :server_import_location_name, :import_type, :rights, :preservation_level,
                                     import_field_mappings_attributes: [:id, :key, {value: []}])
      if can? :publish, GenericFile
        permitted_params.merge! params.require(:import).permit(:visibility)
      end

      permitted_params
    end

end
