class DownloadsController < ApplicationController
  include Sufia::DownloadsControllerBehavior

  def show
    if params[:file] == "content"
      # If the user cannot edit the asset, we will redirect them to the low_resolution version download.
      if current_user.nil? || !(current_user.can? :edit, asset)
        redirect_to sufia.download_path(asset)
      end
    end

    super
  end

  def file_name
    params[:filename] || file.original_name || (asset.respond_to?(:label) && asset.label) || file.id
  end

  def self.default_file_path
    "low_resolution"
  end

end