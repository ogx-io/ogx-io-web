class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  include Mentionable
  include BodyConvertable
  include SoftlyDeletable

  field :b, as: :body, type: String

  field :ip, as: :user_ip, type: String
  field :ua, as: :user_agent, type: String
  field :rf, as: :referer, type: String

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user
  belongs_to :board

  validates_presence_of :body, message: "评论内容不能为空"
  validates_length_of :body, maximum: 200, message: "评论内容不能超过200个字"

  after_create :update_user, :send_comment_notification

  def author
    self.user
  end

  def topic
    self.commentable.topic
  end

  def send_comment_notification
    Notification::Comment.create(user: commentable.author, comment: self) if self.author != commentable.author
  end

  def update_user
    self.user.update(last_comment_at: self.created_at)
  end

end
