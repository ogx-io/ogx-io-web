require 'rails_helper'

RSpec.describe Notification::Comment, :type => :model do
  let(:post) { create(:post) }
  let(:comment) { create(:comment, commentable: post) }

  subject { create(:notification_comment, comment: comment) }

  it 'belongs_to comment' do
    expect(subject.comment).to be comment
  end
end
