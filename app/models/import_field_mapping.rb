class ImportFieldMapping < ActiveRecord::Base
  belongs_to :import
  serialize :value, Array
  KEYS = [:resource_type, :title, :creator, :contributor, :description,
          :tag, :publisher, :date_created, :subject, :language,
          :identifier, :based_near, :related_url, :staff_notes, :spatial,
          :alternative, :temporal, :format, :work_type, :source, :materials,
          :measurements, :part_of, :bibliographic_citation, :provenance, :collection_identifier].freeze
end
