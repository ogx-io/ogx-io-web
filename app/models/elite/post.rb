class Elite::Post < Elite::Node

  include BodyConvertable
  include LogicDeletable

  field :b, as: :body, type: String

  belongs_to :board
  belongs_to :author, class_name: "User", inverse_of: :posts
  belongs_to :topic, touch: true
end
