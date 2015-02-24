FactoryGirl.define do
  factory :picture do
    user
    association :picturable, factory: :post
  end

end
