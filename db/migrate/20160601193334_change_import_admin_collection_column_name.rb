class ChangeImportAdminCollectionColumnName < ActiveRecord::Migration
  def change
    rename_column :imports, :admin_collection, :admin_collection_id
  end
end
