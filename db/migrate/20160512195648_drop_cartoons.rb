class DropCartoons < ActiveRecord::Migration
  def change
    drop_table :cartoons
  end
end
