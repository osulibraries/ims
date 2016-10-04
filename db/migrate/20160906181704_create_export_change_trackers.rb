class CreateExportChangeTrackers < ActiveRecord::Migration
  def change
    create_table :osul_export_change_trackers do |t|
      t.string :fid
      t.string :object_type
      t.string :user_id

      t.timestamps null: false
    end
  end
end
