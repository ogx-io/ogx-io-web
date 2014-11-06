class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :t, as: :title, type: String
  field :b, as: :body, type: String
  field :p, as: :parent, type: Integer
  field :r, as: :root, type: Integer

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts

end
