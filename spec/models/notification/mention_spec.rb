require 'rails_helper'

RSpec.describe Notification::Mention, :type => :model do
  let(:post) { create(:post) }

  subject { create(:notification_mention, mentionable: post) }

  it 'belongs_to mentionable' do
    expect(subject.mentionable).to be post
  end
end
