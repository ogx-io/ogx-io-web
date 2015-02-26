require 'rails_helper'

RSpec.describe Notification::Comment, :type => :model do

  subject { Notification::Comment }

  it 'belongs_to comment' do
    expect(subject).to belong_to(:comment)
  end
end
