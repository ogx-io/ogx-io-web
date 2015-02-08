module Nodable
  extend ActiveSupport::Concern

  included do
    field :o, as: :order, type: Integer, default: 0
    field :l, as: :layer, type: Integer, default: 0

    has_many :children, class_name: self.to_s, inverse_of: :parent, dependent: :destroy
    belongs_to :parent, class_name: self.to_s, inverse_of: :children
  end

  def parents
    result = []
    p = self.parent
    while p
      result.push(p)
      p = p.parent
    end
    result
  end
end