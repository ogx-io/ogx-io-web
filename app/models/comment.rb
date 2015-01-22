class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  include Mentionable

  field :b, as: :body, type: String
  field :p, as: :parent_id, type: Integer
  field :t, as: :thread, type: String # format: "1.2.1/". It is used for sorting: desc(:thread)
  field :t2, as: :thread2, type: String # format: "1.2.1". It is used for sorting: asc(:thread)
  field :d, as: :deleted, type: Integer, default: 0 # 0: not deleted, 1: deleted by user, 2: deleted by moderator, 3: deleted and hidden by moderator
  field :comment_count, type: Integer, default: 0

  field :ip, as: :user_ip, type: String
  field :ua, as: :user_agent, type: String
  field :rf, as: :referer, type: String

  scope :normal, -> { where(deleted: 0) }
  scope :deleted, -> { where(deleted: {'$gt' => 0}) }
  scope :pub, -> { where(deleted: {'$lt' => 3}) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :deleter, class_name: "User"
  belongs_to :resumer, class_name: "User"
  belongs_to :board
  belongs_to :reply_to, class_name: "Comment" # the comment id that this comment reply to

  validates_presence_of :body, message: "评论内容不能为空"
  validates_length_of :body, maximum: 200, message: "评论内容不能超过200个字"

  attr_accessor :max_depth # remember setting the maximum depth before saving. default is 2

  before_create :set_thread
  after_create :update_user, :send_comment_notification

  def author
    self.user
  end

  def send_comment_notification
    Notification::Comment.create(user: commentable.author, comment: self) if self.author != commentable.author
  end

  def set_thread
    @max_depth ||= 2
    self.reply_to_id = self.parent_id
    if self.parent_id != 0
      parent = Comment.find(self.parent_id)
      parent_depth = parent.thread.split('.').length
      if parent_depth >= @max_depth
        self.parent_id = parent.parent_id
      end
      parent = Comment.where(_id: self.parent_id).find_and_modify({"$inc" => { comment_count: 1 }}, new: true)
      self.thread2 = parent.thread2 + '.' + get_thread_num(parent.comment_count)
    else
      parent = self.commentable_type.constantize.where(_id: self.commentable_id).find_and_modify({"$inc" => { comment_count: 1 }}, new: true)
      self.thread2 = get_thread_num(parent.comment_count)
    end
    self.thread = self.thread2 + '/'
  end

  def update_user
    self.user.update(last_comment_at: Time.now)
  end

  def deleted?
    self.deleted > 0
  end

  def resume_by(user)
    self.deleted = 0
    self.resumer = user
    self.save
  end

  def delete_by(user)
    if self.user == user
      self.deleted = 1
    else
      self.deleted = 2
    end
    if get_tree.normal.count <= 1
      self.deleted = 3
    end
    self.deleter = user
    self.save
  end

  def delete_all_by(user)
    get_tree.update_all(deleted: 3, deleter_id: user.id)
  end

  def get_tree
    thread_array = self.thread2.split('.')
    thread_array[thread_array.length - 1] = get_thread_num(thread_array[thread_array.length - 1].to_i - 1)
    next_thread = thread_array.join('.') + '/'
    Comment.where(commentable_type: self.commentable_type, commentable_id: self.commentable_id, t: {'$lte' => self.thread, '$gt' => next_thread})
  end

  def self.new_from_parent(parent)
    comment = self.new
    comment.commentable = parent.commentable
    comment.parent_id = parent.id
    comment
  end

  private

  def get_thread_num(num)
    sprintf('%03d',num)
  end
end
