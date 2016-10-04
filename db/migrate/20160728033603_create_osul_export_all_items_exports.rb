class CreateOsulExportAllItemsExports < ActiveRecord::Migration
  def change
    create_table :osul_export_all_items_exports do |t|
      t.string :fid
      t.string :resource_type
      t.string :content

      t.timestamps null: false
    end
  end
end
