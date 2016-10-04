class ChangeMoreColumnTypesToTextInExport < ActiveRecord::Migration
  def up
    change_column :osul_export_export_generic_file_items, :bibliographic_citation, :text
    change_column :osul_export_export_generic_file_items, :tag, :text
    change_column :osul_export_export_generic_file_items, :rights, :text
    change_column :osul_export_export_generic_file_items, :provenance, :text
    change_column :osul_export_export_generic_file_items, :subject, :text
    change_column :osul_export_export_generic_file_items, :language, :text
    change_column :osul_export_export_generic_file_items, :based_near, :text
    change_column :osul_export_export_generic_file_items, :related_url, :text
    change_column :osul_export_export_generic_file_items, :work_type, :text
    change_column :osul_export_export_generic_file_items, :spatial, :text
    change_column :osul_export_export_generic_file_items, :alternative, :text
    change_column :osul_export_export_generic_file_items, :temporal, :text
    change_column :osul_export_export_generic_file_items, :format, :text
    change_column :osul_export_export_generic_file_items, :source, :text
    change_column :osul_export_export_generic_file_items, :part_of, :text
  end

  def down
    change_column :osul_export_export_generic_file_items, :bibliographic_citation, :string
    change_column :osul_export_export_generic_file_items, :tag, :string
    change_column :osul_export_export_generic_file_items, :rights, :string
    change_column :osul_export_export_generic_file_items, :provenance, :string
    change_column :osul_export_export_generic_file_items, :subject, :string
    change_column :osul_export_export_generic_file_items, :language, :string
    change_column :osul_export_export_generic_file_items, :based_near, :string
    change_column :osul_export_export_generic_file_items, :related_url, :string
    change_column :osul_export_export_generic_file_items, :work_type, :string
    change_column :osul_export_export_generic_file_items, :spatial, :string
    change_column :osul_export_export_generic_file_items, :alternative, :string
    change_column :osul_export_export_generic_file_items, :temporal, :string
    change_column :osul_export_export_generic_file_items, :format, :string
    change_column :osul_export_export_generic_file_items, :source, :string
    change_column :osul_export_export_generic_file_items, :part_of, :string
  end
end