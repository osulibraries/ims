class AddImageFieldsToImportedRecords < ActiveRecord::Migration
  def change
    add_column :imported_records, :has_image, :string
    add_column :imported_records, :has_watermark, :string
  end
end
