class CreateRoles < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? 'roles'
      change_table :roles do |t|
        t.string :key
        t.timestamps
      end
    else
      create_table :roles do |t|
        t.string :name
        t.string :key
        t.timestamps
      end
    end
  end

  def down
    drop_table :roles
  end
end
