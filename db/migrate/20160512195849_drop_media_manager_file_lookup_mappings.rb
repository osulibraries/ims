class DropMediaManagerFileLookupMappings < ActiveRecord::Migration
  def change
    drop_table :media_manager_file_lookup_mappings
  end
end
