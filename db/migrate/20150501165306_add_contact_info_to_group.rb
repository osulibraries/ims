class AddContactInfoToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :contact_info, :text
  end
end
