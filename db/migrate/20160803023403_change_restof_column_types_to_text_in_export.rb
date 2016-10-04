class ChangeRestofColumnTypesToTextInExport < ActiveRecord::Migration
  def up
    change_column :osul_export_export_generic_file_items, :date_created, :text
    change_column :osul_export_export_generic_file_items, :publisher, :text
  end

  def down
    change_column :osul_export_export_generic_file_items, :date_created, :string
    change_column :osul_export_export_generic_file_items, :publisher, :string
  end
end
