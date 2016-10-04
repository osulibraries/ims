json.array!(@export_change_trackers) do |export_change_tracker|
  json.extract! export_change_tracker, :id, :id, :object_type, :user_id
  json.url export_change_tracker_url(export_change_tracker, format: :json)
end
