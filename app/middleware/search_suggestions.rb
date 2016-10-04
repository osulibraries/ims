class SearchSuggestions

  #whitelist of search fields that can be sent as parameters
  VALID_SEARCH_FIELDS = %w(dateSuggester subjectSuggester creatorSuggester tagSuggester part_ofSuggester temporalSuggester work_typeSuggester formatSuggester bibliographic_citationSuggester spatialSuggester materialSuggester material_typeSuggester languageSuggester locationSuggester measurement_typeSuggester measurement_unitSuggester)

  #We are bypassing the middleware stack in order to serve up the date autocomplete suggestions much faster and without loading the entire stack
  def initialize(app)
    @app = app
  end
  
  def call(env)

    #make sure we are intercepting the right route by checking the path (expecting: /autocomplete/field)
    route_path = env["PATH_INFO"].split('/')
    #in production there will be a /ims prefix, we need to remove it
    route_path.delete('ims') if route_path.include?('ims')
    if route_path.count == 3 and route_path[1] == "autocomplete" and  VALID_SEARCH_FIELDS.include?(route_path[2])
      request = Rack::Request.new(env)

      terms = []
      unless request.params["term"].blank? 

        field = route_path[2]
        term = request.params["term"] || ''
        link = ActiveFedora::SolrService.instance.conn.options[:url] + "/suggest?suggest=true&suggest.build=true&suggest.dictionary=" + field +"&wt=json&suggest.q=" + term
        response = HTTParty.get(link)

        entries =  response.parsed_response["suggest"][field][term]["suggestions"]

        unless entries.blank?
          entries.each do |entry|
            terms << entry["term"]
          end
        end
      end
      
      [200, {"Content-Type" => "appication/json"}, [terms.to_json]]
    else
      @app.call(env)
    end
  end
end
