class Elite::Node
  include Mongoid::Document
  include Mongoid::Timestamps

  field :t, as: :title, type: String

  belongs_to :moderator, class_name: "User"

end
