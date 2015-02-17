FactoryGirl.define do

  factory :root_category, class: Category do
    name 'root'
    path 'root'
    layer 0
    order 0
  end

  factory :category do
    name 'TestCategory'
    path 'test_category'
    association :parent, factory: :root_category
  end

end
