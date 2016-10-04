class ChangeColumnTypesToTextInExport < ActiveRecord::Migration
  def up
    change_column :osul_export_export_generic_file_items, :materials, :text
    change_column :osul_export_export_generic_file_items, :measurements, :text
    change_column :osul_export_export_generic_file_items, :description, :text
    change_column :osul_export_all_items_exports, :content, :text
  end

  def down
    change_column :osul_export_export_generic_file_items, :materials, :string
    change_column :osul_export_export_generic_file_items, :measurements, :string
    change_column :osul_export_export_generic_file_items, :description, :string
    change_column :osul_export_all_items_exports, :content, :string
  end
end
