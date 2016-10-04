class CreateOsulExportCategorizeExportLists < ActiveRecord::Migration
  def change
    create_table :osul_export_categorize_export_lists do |t|
      t.string :fid
      t.string :resource_type

      t.timestamps null: false
    end
  end
end
