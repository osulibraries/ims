class CreateImportFieldMappings < ActiveRecord::Migration
  def change
    create_table :import_field_mappings do |t|
      t.belongs_to :import, index: true
      t.string :key
      t.integer :value

      t.timestamps
    end
  end
end
