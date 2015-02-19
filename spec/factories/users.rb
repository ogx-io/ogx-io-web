FactoryGirl.define do
  factory :user do
    name "test_user"
    nick "TestUser"
    email "test@example.com"
    password "please123"
    confirmed_at { Time.now }

    trait :admin do
      role 'admin'
    end

  end

  factory :moderator, class: User do
    name 'moderator'
    nick 'Moderator'
    email 'moderator@example.com'
    password 'please123'
    confirmed_at { Time.now }
  end
end
