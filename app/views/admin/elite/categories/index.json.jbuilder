json.array!(@admin_elite_categories) do |admin_elite_category|
  json.extract! admin_elite_category, :id
  json.url admin_elite_category_url(admin_elite_category, format: :json)
end
