class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name
      t.boolean :includes_headers, default: true
      t.integer :status, default: 0
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
