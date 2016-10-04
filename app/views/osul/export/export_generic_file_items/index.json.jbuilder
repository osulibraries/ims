json.array!(@export_generic_file_items) do |generic_file_item|
  json.merge! generic_file_item.attributes
end
