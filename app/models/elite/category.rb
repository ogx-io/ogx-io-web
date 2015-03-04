class Elite::Category < Elite::Node

  def self.root_for(board)
    if self.where(board_id: board.id).exists?
      return self.where(board_id: board.id).first
    else
      new_category = self.new
      new_category.board = board
      new_category.layer = 0
      new_category.save
      return new_category
    end
  end

  def name
    self.layer == 0 ? self.board.name : self.title
  end

  def author
    self.moderator
  end
end
