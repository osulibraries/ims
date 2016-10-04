class CreateMediaManagerFileLookupMapping < ActiveRecord::Migration
  def change
    create_table :media_manager_file_lookup_mappings, :id => false do |t|
      t.string :itemid
      t.string :filename
    end
  end
end


