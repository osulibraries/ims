json.array!(@trashed_items) do |trashed_item|
  json.extract! trashed_item, :id, :generic_file_id, :depositor
  json.url trashed_item_url(trashed_item, format: :json)
end
