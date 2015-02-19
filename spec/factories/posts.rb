# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    title 'test title'
    body 'test body'
    association :board, factory: :board
    association :author, factory: :user
  end
end
