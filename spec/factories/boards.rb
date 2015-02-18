# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :board do
    name 'TestBoard'
    path 'test_board'
    parent { Node.root }
  end
end
