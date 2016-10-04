class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :user
      t.references :group
      t.timestamps
    end
  end
end
