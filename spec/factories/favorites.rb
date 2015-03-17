FactoryGirl.define do
  factory :favorite do
    user
    association :favorable, factory: :board
  end

end
