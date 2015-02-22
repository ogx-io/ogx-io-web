require 'rails_helper'

RSpec.describe Elite::Category, :type => :model do

  let(:category) { create(:elite_category) }
  let(:board) { create(:board) }
  let(:root) { Elite::Category.root_for(board) }

  it "has a valid root" do
    expect(root.valid?).to be_truthy
  end

  it "has a parent" do
    cate = Elite::Category.new(title: 'test', board: board)
    expect(cate.valid?).to be_falsey
    cate.parent = root
    expect(cate.valid?).to be_truthy
  end

  it "can have many children" do
    child1 = create(:elite_category, title: 'Child1', parent: category)
    child2 = create(:elite_category, title: 'Child2', parent: category)
    expect(category.children.count).to eq(2)
  end

  it "has the unique path" do
    child1 = create(:elite_category, title: 'Child', parent: category)
    child2 = build(:elite_category, title: 'Child', parent: category)
    expect(child2.valid?).to be_falsey
  end

end
