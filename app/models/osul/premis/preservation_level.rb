# TODO: Actually hook this up. Currently a term on GenericFile.
module Osul
  module PREMIS
    class PreservationLevel < ActiveFedora::Base

     has_many :generic_files, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf, class_name: "GenericFile"

      

      property :date_assigned, predicate: ::RDF::URI.new("http://www.loc.gov/standards/premis/v2/premis-v2-3.xsd#preservationLevelDateAssigned"), multiple: false do |index|
        index.as :stored_searchable
      end

      def display_terms
        value + ((date_assigned.nil? || date_assigned.empty?) ? "" : " - assigned: #{date_assigned}")
      end
    end
  end
end