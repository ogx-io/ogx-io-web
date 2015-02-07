class Elite::Category < Elite::Node

  def self.root_for(board)
    self.find_or_create_by(board_id: board.id)
  end

  def name
    self.layer == 0 ? self.board.name : self.title
  end

  def author
    self.moderator
  end
end
