class AddfolderFieldToImportedRecord < ActiveRecord::Migration
  def change
    add_column :imported_records, :folder_name, :string
  end
end
