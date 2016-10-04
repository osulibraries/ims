class AddServerBrowseFieldsToImport < ActiveRecord::Migration
  def change
    add_column :imports, :server_import_location_name, :string
    add_column :imports, :import_type, :string
  end
end
