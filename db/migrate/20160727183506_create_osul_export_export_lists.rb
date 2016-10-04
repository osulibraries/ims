class CreateOsulExportExportLists < ActiveRecord::Migration
  def change
    create_table :osul_export_export_lists do |t|
      t.string :fid

      t.timestamps null: false
    end
  end
end
