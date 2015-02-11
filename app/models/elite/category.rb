class Elite::Category < Elite::Node

  validate :check_uniqueness

  def check_uniqueness
    if Elite::Category.where(parent_id: self.parent_id, title: self.title).exists?
      errors.add(:title, "this title already exists!")
    end
  end

  def self.root_for(board)
    if self.where(board_id: board.id).exists?
      return self.where(board_id: board.id).first
    else
      new_category = self.new
      new_category.board = board
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
