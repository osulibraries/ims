class AddUnitIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :unit_id, :integer
  end
end
