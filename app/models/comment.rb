class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :b, as: :body, type: String
  field :p, as: :parent_id, type: Integer
  field :t, as: :thread, type: String # format: "1.1.1/". It is used for sorting: desc(:thread)
  field :d, as: :deleted, type: Integer, default: 0 # 0: not deleted, 1: deleted by user, 2: deleted by moderator, 3: deleted and hidden by moderator
  field :comment_count, type: Integer, default: 0

  field :ip, as: :user_ip, type: String
  field :ua, as: :user_agent, type: String
  field :rf, as: :referer, type: String

  scope :normal, -> { where(deleted: {'$lt' => 3}) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates_presence_of :body, message: "内容不能为空"
  validates_length_of :body, maximum: 200, message: "内容不能超过200个字"

  attr_accessor :max_depth # remember setting the maximum depth before saving. default is 999

  before_create :set_thread

  def set_thread
    @max_depth ||= 999
    if self.parent_id != 0
      parent = Comment.find(self.parent_id)
      parent_depth = parent.thread.split('.').length
      if parent_depth >= @max_depth
        self.parent_id = parent.parent_id
      end
      parent = Comment.where(_id: self.parent_id).find_and_modify({"$inc" => { comment_count: 1 }}, new: true)
      self.thread = parent.thread.split('/')[0] + ".#{parent.comment_count}/"
    else
      parent = self.commentable_type.constantize.where(_id: self.commentable_id).find_and_modify({"$inc" => { comment_count: 1 }}, new: true)
      self.thread = "#{parent.comment_count}/"
    end
  end
end
