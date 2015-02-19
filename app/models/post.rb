class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  include Sidable
  include Mentionable
  include BodyConvertable
  include SoftDeletable

  field :t, as: :title, type: String
  field :b, as: :body, type: String
  field :f, as: :floor, type: Integer
  field :top , type: Integer, default: 0

  field :comment_count, type: Integer, default: 0

  field :ip, as: :user_ip, type: String
  field :ua, as: :user_agent, type: String
  field :rf, as: :referer, type: String

  scope :top, -> { where(top: {'$gt' => 0}) }

  validates_presence_of :title, message: "必须要有标题"
  validates_length_of :title, maximum: 40, message: "标题太长了"

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts
  belongs_to :topic, touch: true
  belongs_to :parent, class_name: "Post"

  has_many :comments, as: :commentable
  has_many :pictures, as: :picturable

  has_one :elite_post, :class_name => 'Elite::Post', inverse_of: :original

  before_create :set_topic_and_floor
  after_create :update_topic, :update_author, :send_notifications

  def send_notifications
    if self.parent
      Notification::PostReply.create(user: self.parent.author, post: self) if self.author != self.parent.author
    end
  end

  def set_topic_and_floor
    if self.topic.nil?
      topic = self.topic = Topic.create(board_id: self.board_id, user_id: self.author_id)
    else
      topic = Topic.new_floor(self.topic_id)
    end
    self.floor = topic.last_floor
  end

  def update_topic
    self.topic.update(replied_at: self.created_at)
  end

  def update_author
    self.author.update(last_post_at: Time.now)
  end

  def last_commenting_user
    self.comments.normal.last.user
  end

  def last_commented_at
    self.comments.normal.last.created_at
  end

  def after_delete_by(user)
    if self.topic.posts.normal.count == 0
      self.topic.delete_by(user)
    end
  end

  def after_resume_by(user)
    if self.topic.deleted?
      self.topic.resume_by(user)
    end
  end

  def is_elite?
    self.elite_post && !self.elite_post.deleted?
  end

  def is_top?
    self.top > 0
  end

end
