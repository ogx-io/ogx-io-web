json.array!(@nodes) do |node|
  json.extract! node, :id
  json.url node_url(node, format: :json)
end
