class Board < Node

  field :i, as: :intro, type: String

  belongs_to :creator, class_name: "User"
  has_and_belongs_to_many :moderators, class_name: "User", inverse_of: :managing_boards
  has_many :posts
  has_many :topics
  has_many :blocked_users, as: :blockable

  def is_moderator?(user)
    return false if not user
    self.moderator_ids.include?(user.id)
  end

  def is_blocking?(user)
    self.blocked_users.each do |u|
      return true if u.user_id == user.id
    end
    false
  end

  def elite_root
    Elite::Category.root_for(self)
  end
end
