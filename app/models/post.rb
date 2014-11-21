class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :t, as: :title, type: String
  field :b, as: :body, type: String
  field :p, as: :parent, type: Integer
  field :f, as: :floor, type: Integer

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts
  belongs_to :topic

  before_create :set_topic_and_floor
  after_create :update_topic

  def set_topic_and_floor
    if self.topic.nil?
      topic = self.topic = Topic.create(board_id: self.board_id)
    else
      topic = Topic.new_floor(self.topic_id)
    end
    self.floor = topic.last_floor
  end

  def update_topic
    self.topic.update(replied_at: self.created_at)
  end
end
