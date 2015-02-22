FactoryGirl.define do
  factory :notification_post_reply, :class => 'Notification::PostReply' do
    user
    post
  end

end
