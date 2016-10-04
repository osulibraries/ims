class ChangeImportFieldMappingValueColumnType < ActiveRecord::Migration
  def up
    change_column :import_field_mappings, :value, :string
  end

  def down
    change_column :import_field_mappings, :value, :integer
  end
end
