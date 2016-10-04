class ChangeTitleColumnTypesToTextInExport < ActiveRecord::Migration
  def up
    change_column :osul_export_export_generic_file_items, :title, :text
  end

  def down
    change_column :osul_export_export_generic_file_items, :title, :string
  end
end
