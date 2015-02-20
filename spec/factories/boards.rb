# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :board do
    sequence(:name) {|n| "TestBoard#{n}"}
    sequence(:path) {|n| "test_board#{n}"}
    parent { Node.root }
  end
end
