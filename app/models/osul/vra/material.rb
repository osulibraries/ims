module Osul
  module VRA
    class Material < ActiveFedora::Base
      after_save :track_material_change

      belongs_to :generic_file, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf, class_name: "GenericFile"

      property :material, predicate: ::RDF::URI.new('http://purl.org/vra/material'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
   
      property :material_type, predicate: ::RDF::URI.new('http://purl.org/vra/Material#type'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
  
      def track_material_change
        Osul::Export::ChangeTracker.create!(fid: self.id, object_type: self.class)
      end

      def display_terms
        material + ((material_type.present?) ? ' - ' + material_type : "")
      end

    end
  end
end
