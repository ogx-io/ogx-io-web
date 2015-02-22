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
    sequence(:name) {|n| "moderator#{n}"}
    sequence(:nick) {|n| "Moderator#{n}"}
    sequence(:email) {|n| "moderator#{n}@example.com" }
    password 'please123'
    confirmed_at { Time.now }
  end
end
