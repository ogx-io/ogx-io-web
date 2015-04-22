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

  factory :github_user, class: User do
    name 'github_user'
    nick "Github User"
    email 'git@hubuser.net'
    password 'you_guess_too'
    github_access_token 'abcde'
    github_id 1
    confirmed_at { Time.now }
  end
  factory :github_user_2, class: User do
    name 'github_user_2'
    nick "Github User 2"
    email 'git@hubuser.cn'
    password 'you_guess_too'
    github_access_token 'abcdo'
    github_id 2
    confirmed_at { Time.now }
  end
  factory :unbinded_github_user, class: User do
    email 'gith@ubuser.com'
    nick 'Unbinde Qser'
    password 'Iamrandomxwqet'
    name 'ussgu'
    confirmed_at { Time.now }
  end
end
