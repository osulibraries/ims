module Osul::SearchBuilder
  # Limits search results just to GenericFiles and Admin Sets
  # @param solr_parameters the current solr parameters
  def only_generic_files_and_admin_sets(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{Solrizer.solr_name("has_model", :symbol)}:(\"GenericFile\" \"Hydra::Admin::Collection\")"
  end

  def show_only_admin_sets(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] += [
          ActiveFedora::SolrService.construct_query_for_rel(has_model: Hydra::Admin::Collection.to_class_uri)
      ]
  end

  # def scope_to_unit(solr_parameters)
  #   solr_parameters[:fq] ||= []
  #   solr_parameters[:fq] += scope.current_user.units.each.collect {|g| "#{Solrizer.solr_name("unit")}:(#{g.key})" }
  #   binding.pry
  #    # scope.current_user.units.each.collect {|g| ActiveFedora::SolrService.construct_query_for_rel(unit: g.key)}
  # end


end