json.array!(@elite_posts) do |elite_post|
  json.extract! elite_post, :id
  json.url elite_post_url(elite_post, format: :json)
end
