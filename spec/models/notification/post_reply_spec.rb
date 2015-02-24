require 'rails_helper'

RSpec.describe Notification::PostReply, :type => :model do
  let(:post) { create(:post) }

  subject { create(:notification_post_reply, post: post) }

  it 'belongs to post' do
    expect(subject.post).to be post
  end
end
