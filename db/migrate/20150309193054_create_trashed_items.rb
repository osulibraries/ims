class CreateTrashedItems < ActiveRecord::Migration
  def change
    create_table :trashed_items do |t|
      t.string :generic_file_id
      t.string :visibility
      t.string :collection_id
      t.string :depositor

      t.timestamps
    end
  end
end
