class AddAttachmentCsvToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.attachment :csv
      t.attachment :images
    end
  end

  def self.down
    remove_attachment :imports, :csv
    remove_attachment :imports, :images
  end
end
