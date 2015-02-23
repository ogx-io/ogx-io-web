FactoryGirl.define do
  factory :blocked_user do
    association :blockable, factory: :board
    user
    association :blocker, factory: :moderator
  end

end
