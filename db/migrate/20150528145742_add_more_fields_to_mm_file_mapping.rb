class AddMoreFieldsToMmFileMapping < ActiveRecord::Migration
  def change
    add_column :media_manager_file_lookup_mappings, :file_extension, :string
    add_column :media_manager_file_lookup_mappings, :file_size, :integer, :limit => 8
  end
end
