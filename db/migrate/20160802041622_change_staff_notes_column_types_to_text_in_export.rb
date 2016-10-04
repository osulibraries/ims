class ChangeStaffNotesColumnTypesToTextInExport < ActiveRecord::Migration
   def up
    change_column :osul_export_export_generic_file_items, :staff_notes, :text
  end

  def down
    change_column :osul_export_export_generic_file_items, :staff_notes, :string
  end
end
