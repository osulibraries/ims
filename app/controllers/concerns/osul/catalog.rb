module Osul
  module Catalog
    extend ActiveSupport::Concern
    
    included do
      self.search_params_logic += [:only_generic_files_and_admin_sets]

      configure_blacklight do |config|
        config.add_facet_field("unit_tesim", 
                              label: "Unit",
                              limit: 5,
                              helper_method: :get_group_name_from_key)
        config.add_facet_field("isMemberOfCollection_ssim",
                               label: "Collection",
                               limit: 5,
                               helper_method: :get_title_from_uri)
        config.add_facet_field solr_name("sub_collection", :facetable), label: "Sub-Collection", limit: 5
        config.add_facet_field solr_name("date", :facetable), label: "Date", limit: 5
        config.add_facet_field solr_name("creator", :facetable), label: "Creator", limit: 5
        config.add_facet_field solr_name("subject", :facetable), label: "Subject", limit: 5
        config.add_facet_field solr_name("spatial", :facetable), label: "Place", limit: 5
        config.add_facet_field solr_name("temporal", :facetable), label: "Time period", limit: 5
        config.add_facet_field solr_name("work_type", :facetable), label: "Genre", limit: 5
        config.add_facet_field solr_name("format", :facetable), label: "Format", limit: 5
        #config.add_facet_field solr_name("resource_type", :facetable), label: "Type", limit: 5
      end
    end
  end
end
