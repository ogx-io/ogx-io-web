require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  it 'can get pretty path for a node' do
    category = create(:category, name: 'One', path: 'one')
    board = create(:board, name: 'Two', path: 'two', parent: category)
    expect(helper.pretty_path_for_node(board)).to eq('/one/two')
  end

end