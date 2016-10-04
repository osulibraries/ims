class Osul::Export::ExportGenericFileItemsController < ApplicationController

  # GET /export/change_trackers
  # GET /export/change_trackers.json
  def index
    @export_generic_file_items = Osul::Export::ExportGenericFileItem.offset(params[:offset]).limit(params[:limit])
  end

end
