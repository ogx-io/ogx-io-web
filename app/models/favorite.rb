class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, inverse_of: :favorites
  belongs_to :favorable, polymorphic: true
end
