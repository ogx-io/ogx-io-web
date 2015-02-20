require 'rails_helper'

RSpec.describe Board, :type => :model do

  it "should has a parent" do
    board = Board.new(name: 'test', path: 'test')
    expect(board.valid?).to be_falsey
    board.parent = create(:category)
    expect(board.valid?).to be_truthy
  end

  it "should have the unique path" do
    board1 = create(:board, name: 'TestBoard1', path: 'test', parent: Node.root)
    board2 = build(:board, name: 'TestBoard', path: 'test', parent: Node.root)
    expect(board2.valid?).to be_falsey
    board2.path = 'test2'
    expect(board2.valid?).to be_truthy
  end

end
