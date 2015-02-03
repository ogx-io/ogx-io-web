class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :n, as: :name, type: String
  field :p, as: :path, type: String # like 'a/b/c', must be unique
  field :o, as: :order, type: Integer, default: 0
  field :l, as: :layer, type: Integer, default: 0
  enum :status, [:normal, :blocked, :deleted], default: :normal

  scope :categories, -> { where(_type: 'Category') }
  scope :boards, -> { where(_type: 'Board') }
  scope :normal, -> { where(status: :normal) }

  has_many :children, class_name: "Node", inverse_of: :parent
  belongs_to :parent, class_name: "Node", inverse_of: :children

  before_save :set_parent

  validates_uniqueness_of :path, message: "路径已存在"
  validate :parent_presence

  def parent_presence
    a = self.path.split('/')
    if a.length > 1
      a.pop
      pp = a.join('/')
      if !Node.where(path: pp).exists?
        errors.add(:path, "parent \"#{pp}\" does not exist")
      end
    end
  end

  def set_parent
    a = self.path.split('/')
    a.pop
    if a.length > 0
      self.parent = Node.where(path: a.join('/')).first
    end
    self.layer = a.length
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

  def last_path
    self.path.split('/').pop
  end

  def self.root
    self.where(path: 'root').first
  end
end
