json.array!(@import_field_mappings) do |import_field_mapping|
  json.extract! import_field_mapping, :id, :import_id, :key, :value
  json.url import_field_mapping_url(import_field_mapping, format: :json)
end
