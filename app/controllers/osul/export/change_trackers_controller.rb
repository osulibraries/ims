class Osul::Export::ChangeTrackersController < ApplicationController

  # GET /export/change_trackers
  # GET /export/change_trackers.json
  def index
    @export_change_trackers = Osul::Export::ChangeTracker.all
  end

end
