require 'rails_helper'

RSpec.describe Node, :type => :model do

  it 'can get node by path' do
    category = create(:category, name: 'One', path: 'one')
    board = create(:board, name: 'Two', path: 'two', parent: category)
    node = Node.get_node_by_path('one/two')
    expect(node).to eq(board)
  end

  it 'can get full path' do
    category = create(:category, name: 'One', path: 'one')
    board = create(:board, name: 'Two', path: 'two', parent: category)
    expect(board.full_path).to eq('root/one/two')
  end

end