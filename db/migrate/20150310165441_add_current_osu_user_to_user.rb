class AddCurrentOsuUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :currently_osu, :boolean
  end
end
