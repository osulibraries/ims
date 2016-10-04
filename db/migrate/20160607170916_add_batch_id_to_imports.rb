class AddBatchIdToImports < ActiveRecord::Migration
  def change
    add_column :imports, :batch_id, :string
  end
end
