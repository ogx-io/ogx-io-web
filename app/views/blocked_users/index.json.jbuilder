json.array!(@blocked_users) do |blocked_user|
  json.extract! blocked_user, :id
  json.url blocked_user_url(blocked_user, format: :json)
end
