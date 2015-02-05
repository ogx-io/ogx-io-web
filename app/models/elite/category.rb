class Elite::Category < Elite::Node

  def self.root_for(board)
    self.find_or_create_by(board_id: board.id, layer: 0, title: 'root')
  end

end
