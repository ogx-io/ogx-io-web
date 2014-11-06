json.array!(@boards) do |board|
  json.extract! board, :id
  json.url board_url(board, format: :json)
end
