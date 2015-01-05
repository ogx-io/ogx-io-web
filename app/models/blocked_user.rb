class BlockedUser
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :blockable, polymorphic: true
  belongs_to :user
  belongs_to :blocker, class_name: "User"
end
