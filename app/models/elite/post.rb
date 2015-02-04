class Elite::Post < Elite::Node

  include BodyConvertable

  field :b, as: :body, type: String
  field :d, as: :deleted, type: Integer, default: 0 # 0: normal, 1:deleted by user, 2: deleted by admin

  scope :normal, -> { where(deleted: 0) }
  scope :deleted, -> { where(deleted: {'$gt' => 0}) }

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts
  belongs_to :topic, touch: true
end
