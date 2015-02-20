FactoryGirl.define do

  factory :category do
    sequence(:name) {|n| "TestCategory#{n}"}
    sequence(:path) {|n| "test_category#{n}"}
    parent { Node.root }
  end

end
