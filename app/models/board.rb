class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :n, as: :name, type: String
  field :p, as: :path, type: String
  field :i, as: :intro, type: String
  enum :status, [:normal, :blocked, :deleted], default: :normal

  belongs_to :board_application
  belongs_to :creator, class_name: "User"
  has_and_belongs_to_many :moderators, class_name: "User", inverse_of: :managing_boards
  has_many :posts
  has_many :topics
  has_many :blocked_users, as: :blockable

  def is_moderator?(user)
    self.moderator_ids.include?(user.id)
  end

  def is_blocked?(user)
    self.blocked_users.each do |u|
      return true if u.user_id == user.id
    end
    false
  end
end
