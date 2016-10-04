class AddKeyToOsulGroup < ActiveRecord::Migration
  def change
    add_column :groups, :key, :string
  end
end
