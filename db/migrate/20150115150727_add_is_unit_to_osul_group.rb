class AddIsUnitToOsulGroup < ActiveRecord::Migration
  def change
    add_column :groups, :is_unit, :boolean
  end
end
