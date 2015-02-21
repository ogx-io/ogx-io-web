require 'rails_helper'

RSpec.describe Topic, :type => :model do

  it 'updates the replied_at field after a new reply occurs' do
    post = create(:post)
    reply1 = create(:post, topic: post.topic, parent: post)
    reply2 = create(:post, topic: post.topic, parent: reply1)
    expect(post.topic.replied_at).to eq(reply2.created_at)
  end

end
