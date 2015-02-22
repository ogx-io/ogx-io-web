require 'rails_helper'

RSpec.describe Elite::Post, :type => :model do

  let(:post) { create(:post) }
  let(:moderator) { create(:moderator) }
  let(:elite_post) do
    Elite::Post.add_post(post, moderator)
    Elite::Post.find_by(original_id: post.id)
  end
  let(:category) { create(:elite_category) }

  it 'can set a post as elite' do
    expect(elite_post.valid?).to be_truthy
    expect(elite_post.body_html).to eq(post.body_html)
    expect(elite_post.author).to eq(post.author)
    expect(elite_post.moderator).to eq(moderator)
    expect(elite_post.parent).to eq(Elite::Category.root_for(elite_post.board))
    expect(elite_post.original).to eq(post)
  end

  it 'can change parent' do
    elite_post.parent = category
    expect(category.children).to include(elite_post)
  end

end
