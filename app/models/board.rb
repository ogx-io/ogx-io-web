class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :n, as: :name, type: String
  field :p, as: :path, type: String
  field :s, as: :strategy, type: String
  field :ru, as: :rule, type: String
  enum :status, [:unknown, :approved, :rejected], default: :unknown

  has_one :board_application
  has_and_belongs_to_many :moderators, class_name: "User", inverse_of: :managing_boards
  has_many :posts
  has_many :topics
end
