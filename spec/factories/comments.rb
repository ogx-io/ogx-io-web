FactoryGirl.define do
  factory :comment do
    body 'test comment'
    user
    association :commentable, factory: :post
  end
end
