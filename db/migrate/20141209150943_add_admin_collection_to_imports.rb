class AddAdminCollectionToImports < ActiveRecord::Migration
  def change
    add_column :imports, :admin_collection, :string
  end

end
