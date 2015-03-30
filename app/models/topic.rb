class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  include SoftlyDeletable

  field :f, as: :last_floor, type: Integer, default: 0
  field :r_at, as: :replied_at, type: Time
  field :l, as: :lock, type: Integer, default: 0 # 0: unlocked, 1: locked by user, 2: locked by moderator
  field :cc, as: :click_count, type: Integer, default: 0

  has_many :posts
  belongs_to :board, touch: true
  belongs_to :user
  belongs_to :locker, class_name: 'User'
  belongs_to :unlocker, class_name: 'User'

  def move_to_board(new_board_id)
    self.update(board_id: new_board_id)
    self.posts.each do |post|
      post.update(board_id: new_board_id)
      post.comments.each do |comment|
        comment.update(board_id: new_board_id)
      end
    end
  end

  def inc_click_count
    self.inc(click_count: 1)
  end

  def author
    self.user
  end

  def title
    self.posts.asc(:floor).first.title
  end

  def last_replying_user
    self.posts.normal.last.author
  end

  def last_replied_at
    self.posts.normal.last.created_at
  end

  def lock_by(user)
    if user == self.author
      self.lock = 1
    else
      self.lock = 2
    end
    self.locker = user
    self.save
  end

  def unlock_by(user)
    self.lock = 0
    self.unlocker = user
    self.save
  end

  def locked?
    self.lock != 0
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
