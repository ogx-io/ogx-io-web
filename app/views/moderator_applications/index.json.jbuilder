json.array!(@moderator_applications) do |moderator_application|
  json.extract! moderator_application, :id
  json.url moderator_application_url(moderator_application, format: :json)
end
