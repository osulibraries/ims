class AddRightsAndMasterObjectFieldsToImport < ActiveRecord::Migration
  def change
    add_column :imports, :rights, :string
    add_column :imports, :preservation_level, :string
  end
end
