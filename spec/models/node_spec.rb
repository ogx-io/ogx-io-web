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

  it 'can get root node' do
    root = Node.root
    expect(root.path).to eq('root')
    expect(root.layer).to eq(0)
  end

  it 'can get public node' do
    node = Node.public
    expect(node.path).to eq('public')
    expect(node.layer).to eq(1)
    expect(node.parent.path).to eq('root')
  end

  it 'can get blog node' do
    node = Node.blog
    expect(node.path).to eq('blog')
    expect(node.layer).to eq(1)
    expect(node.parent.path).to eq('root')
  end
end