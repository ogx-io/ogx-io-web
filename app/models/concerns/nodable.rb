module Nodable
  extend ActiveSupport::Concern

  included do
    field :o, as: :order, type: Integer, default: 0
    field :l, as: :layer, type: Integer, default: 1

    has_many :children, class_name: self.to_s, inverse_of: :parent, dependent: :destroy
    belongs_to :parent, class_name: self.to_s, inverse_of: :children

    validate :check_parent
    before_save :set_layer
  end

  def check_parent
    if self.layer > 0 && self.parent_id.blank?
      errors.add(:parent_id, "必须要有父节点")
    end
  end

  def set_layer
    if self.parent
      self.layer = self.parent.layer + 1
    end
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