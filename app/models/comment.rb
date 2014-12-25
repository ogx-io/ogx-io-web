class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :c, as: :body, type: String
  field :p, as: :parent_id, type: Integer
  field :t, as: :thread, type: String # format: "1.1.1/". It is used for sorting: desc(:thread, :created_at)
  field :d, as: :deleted, type: Integer, default: 0 # 0: not deleted, 1: deleted by user, 2: deleted by moderator

  scope :normal, -> { where(deleted: 0) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  attr_accessor :max_depth # remember setting the maximum depth before saving. default is 3

  before_save :set_thread

  def set_thread
    @max_depth ||= 3
    thread = '1/'
    if self.parent_id != 0
      parent = Comment.find(parent_id)
      parent_depth = parent.thread.split('.').length
      if parent_depth < @max_depth
        thread = parent.thread.split('/')[0] + '.1/'
      else
        thread = parent.thread
      end
    end
    self.thread = thread
  end
end
