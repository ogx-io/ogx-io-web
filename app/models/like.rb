class Like
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :likable, polymorphic: true

  index({user_id: 1, likable_type: 1, likable_id: 1}, {unique: true, drop_dups: true})
end
