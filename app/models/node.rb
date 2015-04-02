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

  validates_presence_of :name, message: I18n.t('mongoid.errors.models.node.attributes.name.blank')
  validates_presence_of :path, message: I18n.t('mongoid.errors.models.node.attributes.path.blank')
  validate :check_path_uniqueness

  def check_path_uniqueness
    node = Node.where(parent_id: self.parent_id, path: self.path).first
    unless node.nil? || node.id == self.id
      errors.add(:path, I18n.t('mongoid.errors.models.node.attributes.path.taken'))
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

  def full_path
    paths = []
    node = self
    loop do
      paths.push node.path
      node = node.parent
      break if node.nil?
    end
    paths.reverse!
    paths.join('/')
  end

  def self.root
    root = self.where(path: 'root').first
    unless root
      root = Category.new(name: 'root', path: 'root', layer: 0)
      root.save
    end
    root
  end

  def self.get_node_by_path(path)
    paths = path.split('/')
    node = self.root
    paths.each do |p|
      node = Node.where(parent_id: node.id, path: p).first
      if node.nil?
        return nil
      end
    end
    return node
  end
end
