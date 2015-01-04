class BlockedUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :d, as: :deleted, type: Integer, default: 0 # 0: normal, 1:deleted by user, 2: deleted by admin


  scope :normal, -> { where(deleted: 0) }
  scope :deleted, -> { where(deleted: 1) }

  def deleted?
    self.deleted > 0
  end

  def delete_by(user)
    self.deleted = 1
    self.deleter = user
    self.save
  end

  def block_by(user)
    self.deleted = 0
    self.blocker = user
    self.save
  end

  def self.check_if_blocked(blockable, user)
    self.where(blockable_type: blockable.class.to_s, blackable_id: blockable.id).normal.exist?(user_id: user.id)
  end

  belongs_to :blockable, polymorphic: true
  belongs_to :user
  belongs_to :blocker, class_name: "User"
  belongs_to :deleter, class_name: "User"
end
