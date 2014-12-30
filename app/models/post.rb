class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  include Sidable

  field :t, as: :title, type: String
  field :b, as: :body, type: String
  field :p, as: :parent_id, type: Integer
  field :f, as: :floor, type: Integer
  field :e, as: :elite, type: Integer, default: 0
  field :d, as: :deleted, type: Integer, default: 0 # 0: normal, 1:deleted by user, 2: deleted by admin

  field :comment_count, type: Integer, default: 0

  field :ip, as: :user_ip, type: String
  field :ua, as: :user_agent, type: String
  field :rf, as: :referer, type: String

  validates_presence_of :title, message: "必须要有标题"
  validates_length_of :title, maximum: 40, message: "标题太长了"

  scope :normal, -> { where(deleted: 0) }
  scope :deleted, -> { where(deleted: {'$gt' => 0}) }
  scope :elites, -> { where(elite: 1) }

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts
  belongs_to :topic
  belongs_to :deleter, class_name: "User"
  belongs_to :resumer, class_name: "User"

  has_many :comments, as: :commentable

  before_create :set_topic_and_floor
  after_create :update_topic, :update_author

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

  def deleted?
    self.deleted > 0
  end

  def delete_by(user)
    if self.author == user
      self.deleted = 1
    else
      self.deleted = 2
    end
    self.deleter = user
    self.save
    self.topic.update(deleted: 1) if self.topic.posts.normal.count == 0
  end

  def resume_by(user)
    self.deleted = 0
    self.resumer = user
    self.save
  end

end
