class CreateOsulExportExportGenericFileItems < ActiveRecord::Migration
  def change
    create_table :osul_export_export_generic_file_items do |t|
      t.string :fid
      t.string :date_uploaded
      t.string :identifier
      t.string :resource_type
      t.string :title
      t.string :creator
      t.string :contributor
      t.string :description
      t.string :bibliographic_citation
      t.string :tag
      t.string :rights
      t.string :provenance
      t.string :publisher
      t.string :date_created
      t.string :subject
      t.string :language
      t.string :based_near
      t.string :related_url
      t.string :work_type
      t.string :spatial
      t.string :alternative
      t.string :temporal
      t.string :format
      t.string :staff_notes
      t.string :source
      t.string :part_of
      t.string :preservation_level_rationale
      t.string :preservation_level
      t.string :collection_identifier
      t.string :visibility
      t.string :collection_id
      t.string :depositor
      t.string :handle
      t.string :batch_id
      t.string :collection_id
      t.string :admin_policy_id
      t.string :materials
      t.string :measurements
      t.string :filename
      t.string :image_uri

      t.timestamps null: false
    end
  end
end
