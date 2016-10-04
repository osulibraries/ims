class RemoveColumnsFromImports < ActiveRecord::Migration
  def change
    remove_column :imports, :images_file_name
    remove_column :imports, :images_content_type
    remove_column :imports, :images_file_size
    remove_column :imports, :images_updated_at
  end
end
