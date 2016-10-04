class AddMoreFieldsToImportLogging < ActiveRecord::Migration
  def change
    add_column :imported_records, :success, :boolean
    add_column :imported_records, :message, :text
  end
end
