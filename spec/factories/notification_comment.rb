FactoryGirl.define do
  factory :notification_comment, :class => 'Notification::Comment' do
    user
    comment
  end

end
