module Hydra::Admin::Collections::Metadata
  extend ActiveSupport::Concern
  included do
    # has_metadata 'descMetadata', type: ActiveFedora::SimpleDatastream do |sds|
    #   sds.field :unit, :string
    # end

    # has_attributes :unit, datastream: :descMetadata, multiple: false

    property :unit, predicate: ::RDF::URI.new('https://library.osu.edu/ns#unit'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :title, predicate: RDF::DC.title, multiple: false do |index|
     index.as :stored_searchable
    end
    property :description, predicate: RDF::DC.description, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end
    property :publisher, predicate: RDF::DC.publisher do |index|
      index.as :stored_searchable, :facetable
    end
    property :language, predicate: RDF::DC.language do |index|
      index.as :stored_searchable, :facetable
    end
    property :creator, predicate: RDF::DC.creator do |index|
      index.as :stored_searchable, :facetable
    end
    property :depositor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dpt"), multiple: false do |index|
      index.as :symbol, :stored_searchable
    end
    
  end
end