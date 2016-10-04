class CreateCartoons < ActiveRecord::Migration
  def change
    create_table :cartoons do |t|
      t.string :title
      t.string :creator
      t.string :date_created
      t.string :tag
      t.string :identifier
      t.string :staff_notes
      t.string :alternative
      t.string :temporal
      t.string :format
      t.string :work_type
      t.string :source
      t.string :materials
      t.string :measurements
      t.string :collection_identifier
      t.string :part_of
      t.string :bibliographic_citation
      t.string :description
      t.string :spatial
      t.string :provenance
      t.string :preservation_level_rationale
      t.string :preservation_level
      t.string :rights
      t.string :resource_type
      t.string :contributor
      t.string :publisher
      t.string :language
      t.string :based_near
      t.string :related_url
      t.string :subject
      t.string :spatial
      t.string :image_filename
      t.string :import_id
      t.string :csv_row
      t.string :message
      t.timestamps
    end
  end
end
