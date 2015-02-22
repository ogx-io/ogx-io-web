require 'rails_helper'

RSpec.describe Category, :type => :model do

  it "has a valid root" do
    root = Node.root
    expect(root.valid?).to be_truthy
  end

  it "has a parent" do
    cate = Category.new(name: 'test', path: 'test')
    expect(cate.valid?).to be_falsey
    cate.parent = Node.root
    expect(cate.valid?).to be_truthy
  end

  it "can have many children" do
    cate = create(:category)
    child1 = create(:category, name: 'Child1', path: 'child1', parent: cate)
    child2 = create(:category, name: 'Child2', path: 'child2', parent: cate)
    expect(cate.children.count).to eq(2)
  end

  it "has the unique path" do
    cate = create(:category)
    child1 = create(:category, name: 'Child1', path: 'child', parent: cate)
    child2 = build(:category, name: 'Child2', path: 'child', parent: cate)
    expect(child2.valid?).to be_falsey
  end

end
