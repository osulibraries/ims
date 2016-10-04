class AddVisibilityToImports < ActiveRecord::Migration
  def change
    add_column :imports, :visibility, :string
  end
end
