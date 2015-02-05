json.array!(@elite_categories) do |elite_category|
  json.extract! elite_category, :id
  json.url elite_category_url(elite_category, format: :json)
end
