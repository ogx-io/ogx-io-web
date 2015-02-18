FactoryGirl.define do

  factory :category do
    name 'TestCategory'
    path 'test_category'
    parent { Node.root }
  end

end
