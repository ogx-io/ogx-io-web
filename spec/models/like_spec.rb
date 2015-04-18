require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to have_field(:user_id).of_type(Object) }
  it { is_expected.to have_field(:likable_id).of_type(Object) }
  it { is_expected.to have_field(:likable_type).of_type(String) }
  it { is_expected.to have_field(:author_id).of_type(Object) }

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:post) { create(:post) }
  let(:post_list) { 25.times.collect { |i| create(:post, author: author) } }

  it 'should be unique' do
    Like.create(user: user, likable: post)
    expect {
      Like.create(user: user, likable: post)
    }.to raise_error
  end

  it 'should has the correct likes count for a user' do
    post_list.each do |item|
      Like.create(user: user, likable: item)
    end
    expect(author.got_likes.count).to eq(post_list.count)
  end
end
