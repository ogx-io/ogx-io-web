FactoryGirl.define do
  factory :like do
    association :user
    association :likable, factory: :post
  end

end
