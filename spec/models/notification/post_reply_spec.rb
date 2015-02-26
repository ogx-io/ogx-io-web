require 'rails_helper'

RSpec.describe Notification::PostReply, :type => :model do

  subject { Notification::PostReply }

  it 'belongs to post' do
    expect(subject).to belong_to(:post)
  end
end
