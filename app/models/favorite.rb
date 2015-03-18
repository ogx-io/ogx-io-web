class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, inverse_of: :favorites
  belongs_to :favorable, polymorphic: true

  index({user_id: 1, favorable_type: 1, favorable_id: 1}, {unique: true, background: true})
end
