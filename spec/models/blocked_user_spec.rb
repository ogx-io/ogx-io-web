require 'rails_helper'

RSpec.describe BlockedUser, :type => :model do

  it "can block a user for a board" do
    blocked_user = create(:blocked_user)
    expect(blocked_user.valid?).to be_truthy
  end

end
