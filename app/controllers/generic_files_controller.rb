class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  def new
    raise CanCan::AccessDenied unless can? :create, ActiveFedora::Base
    super
  end


  def update_metadata
    file_attributes = edit_form_class.model_attributes(params[:generic_file])
    actor.update_metadata(file_attributes, params[:visibility])
  end

  def characterize
    Sufia.queue.push(CharacterizeJob.new(@generic_file.id))
    redirect_to sufia.generic_file_path, notice: "A characterization job has been scheduled for #{@generic_file.to_s}"
  end
end