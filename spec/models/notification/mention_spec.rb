require 'rails_helper'

RSpec.describe Notification::Mention, :type => :model do

  subject { Notification::Mention }

  it 'belongs_to mentionable' do
    expect(subject).to belong_to(:mentionable)
  end

end
