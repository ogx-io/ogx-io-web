class Elite::Post < Elite::Node

  include BodyConvertable

  field :b, as: :body, type: String
  field :p_at, as: :posted_at, type: Time

  belongs_to :author, class_name: "User"
  belongs_to :topic, touch: true
  belongs_to :post, touch: true, inverse_of: :elite_post

  def self.has_post?(post)
    Elite::Post.where(post_id: post.id).exists?
  end

  def self.add_post(post, user)
    elite_post = post.elite_post
    if elite_post
      elite_post.resume_by(user)
    else
      elite_post = self.new
      elite_post.moderator = user
      elite_post.title = post.title
      elite_post.author = post.author
      elite_post.body = post.body
      elite_post.body_html = post.body_html
      elite_post.posted_at = post.created_at
      elite_post.post = post
      elite_post.topic = post.topic
      elite_post.board = post.board
      elite_post.parent = post.board.elite_root
      elite_post.save
    end
  end
end
