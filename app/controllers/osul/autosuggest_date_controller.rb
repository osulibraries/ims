class Osul::AutosuggestDateController < ApplicationController

  # GET /groups
  # GET /groups.json
  def index
    #This action is being intercepted by the middleware in order to bypass all the unnecessary processing and return faster result
    #look inside app/middleware/search_suggestions.rb
  end

end