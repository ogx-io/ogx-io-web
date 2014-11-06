class BoardApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :n, as: :name, type: String
  field :p, as: :path, type: String
  field :r, as: :reason, type: String
  field :s, as: :strategy, type: String
  field :ru, as: :rule, type: String
  enum :status, [:unknown, :approved, :rejected], default: :unknown

  belongs_to :applier, class_name: "User", inverse_of: :board_applications
  belongs_to :board

  def approve
    self.update({status: :approved})
    return false if Board.where({name: self.name}).exists?
    board = Board.new
    board.name = self.name
    board.path = self.path
    board.strategy = self.strategy
    board.rule = self.rule
    board.board_application = self
    board.moderators << self.applier
    board.save
  end

  def reject
    self.update({status: :rejected})
  end
end
