class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  include Sidable
  include LogicDeletable

  field :f, as: :last_floor, type: Integer, default: 0
  field :t, as: :top, type: Integer, default: 0 # 0: normal, 1: always on top
  field :r_at, as: :replied_at, type: Time
  field :l, as: :lock, type: Integer, default: 0 # 0: unlocked, 1: locked by user, 2: locked by moderator

  has_many :posts
  belongs_to :board, touch: true
  belongs_to :user

  def author
    user
  end

  def title
    self.posts.first.title
  end

  def last_replying_user
    self.posts.normal.last.author
  end

  def last_replied_at
    self.posts.normal.last.created_at
  end

  def locked?
    self.lock != 0
  end

  def top?
    self.top > 0
  end

  def is_creator?(user)
    user == self.user
  end

  def can_reply_by(user)
    if self.lock != 0
      if self.lock == 2 || self.user != user
        return false
      end
    end
    true
  end

  def self.new_floor(topic_id)
    self.where(_id: topic_id).find_and_modify({"$inc" => { f: 1 }}, new: true)
  end
end
