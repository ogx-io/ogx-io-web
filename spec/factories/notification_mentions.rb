FactoryGirl.define do
  factory :notification_mention, :class => 'Notification::Mention' do
    user
    association :mentionable, factory: :post
  end

end
