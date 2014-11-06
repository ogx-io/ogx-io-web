json.array!(@board_applications) do |board_application|
  json.extract! board_application, :id
  json.url board_application_url(board_application, format: :json)
end
