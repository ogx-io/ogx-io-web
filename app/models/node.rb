class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  include Nodable

  field :n, as: :name, type: String
  field :p, as: :path, type: String # like 'a/b/c', must be unique
  enum :status, [:normal, :blocked, :deleted], default: :normal

  scope :categories, -> { where(_type: 'Category') }
  scope :boards, -> { where(_type: 'Board') }
  scope :normal, -> { where(status: :normal) }

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

  def last_path
    self.path.split('/').pop
  end

  def self.root
    self.where(path: 'root').first
  end
end
