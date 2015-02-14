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
  validates_presence_of :parent_id, message: "必须要有父节点"
  validate :check_path_uniqueness

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
      root = Category.new(name: 'root', path: 'root')
      root.save(validate: false)
    end
    root
  end
end
