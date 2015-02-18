class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  include Nodable

  field :n, as: :name, type: String
  field :p, as: :path, type: String
  enum :status, [:normal, :blocked, :deleted], default: :normal

  scope :categories, -> { where(_type: 'Category') }
  scope :boards, -> { where(_type: 'Board') }
  scope :normal, -> { where(status: :normal) }

  validates_presence_of :name, message: "必须要有名字"
  validates_presence_of :path, message: "必须要有路径"
  validate :check_parent
  validate :check_path_uniqueness

  def check_parent
    if self.layer > 0 && self.parent_id.blank?
      errors.add(:parent_id, "必须要有父节点")
    end
  end

  def check_path_uniqueness
    node = Node.where(parent_id: self.parent_id, path: self.path).first
    unless node.nil? || node.id == self.id
      errors.add(:path, "this path already exists!")
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

  def self.root
    root = self.where(path: 'root').first
    unless root
      root = Category.new(name: 'root', path: 'root', layer: 0)
      root.save
    end
    root
  end
end
