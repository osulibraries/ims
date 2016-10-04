module Sufia
  module Forms
    class BatchEditForm < GenericFileEditForm
      # Overriden because the BatchEdit only handles properties that contain arrays.
      self.terms = [:resource_type, :title, :creator, :bibliographic_citation, :contributor, :abstract, :description, :tag, :rights,
       :publisher, :date_created, :subject, :language, :identifier, :based_near, :related_url, :work_type, 
       :spatial, :alternative, :temporal, :format, :staff_notes, :source, :part_of, :provenance]
    end
  end
end
