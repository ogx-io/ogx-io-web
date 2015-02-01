class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :n, as: :name, type: String
  field :p, as: :path, type: String # like 'a/b/c', must be unique
  enum :status, [:normal, :blocked, :deleted], default: :normal

  has_many :children, class_name: "Node", inverse_of: :parent
  belongs_to :parent, class_name: "Node", inverse_of: :children

  before_save :set_parent

  validate :parents_presence

  def parents_presence
    a = self.path.split('/')
    while a.pop && a.length > 0
      pp = a.join('/')
      if !Node.where(path: pp).exists?
        errors.add(:path, "parent \"#{pp}\" do not exist")
        break
      end
    end
  end

  def set_parent
    a = self.path.split('/')
    a.pop
    if a.length > 0
      self.parent = Node.where(path: a.join('/')).first
    end
  end
end
