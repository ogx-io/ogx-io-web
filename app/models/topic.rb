class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :f, as: :last_floor, type: Integer, default: 0
  field :t, as: :top, type: Integer, default: 0 # 0: normal, 1: always on top
  field :r_at, as: :replied_at, type: Time

  has_many :posts
  belongs_to :board

  def title
    self.posts.first.title
  end

  def self.new_floor(topic_id)
    self.where(_id: topic_id).find_and_modify({"$inc" => { f: 1 }}, new: true)
  end
end
