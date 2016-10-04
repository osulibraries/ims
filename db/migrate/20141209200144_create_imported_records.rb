class CreateImportedRecords < ActiveRecord::Migration
  def change
    create_table :imported_records do |t|
      t.belongs_to :import, index: true
      t.string :generic_file_pid, index: true
      t.integer :csv_row

      t.timestamps
    end
  end
end
