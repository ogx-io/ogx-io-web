FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "test_user#{n}"}
    sequence(:nick) {|n| "TestUser#{n}"}
    sequence(:email) {|n| "test#{n}@example.com" }
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
