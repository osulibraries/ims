class AddUnitToGenericFileItemsExport < ActiveRecord::Migration
  def change
    add_column :osul_export_export_generic_file_items, :unit, :string    
  end
end
