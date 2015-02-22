require 'rails_helper'

RSpec.describe Notification::Base, :type => :model do

  it 'would not exist in the read scope after reading it' do
    user = create(:user)
    notification1 = create(:notification_mention, user: user)
    notification2 = create(:notification_post_reply, user: user)
    user.reload
    expect(user.notifications.unread).to include(notification1, notification2)
    notification1.set_read
    expect(user.notifications.unread).not_to include(notification1)
  end

end
