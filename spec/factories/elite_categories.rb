FactoryGirl.define do
  factory :elite_category, :class => 'Elite::Category' do
    board
    moderator
    sequence(:title) {|n| "elite_category#{n}"}
    parent { Elite::Category.root_for(board) }
  end

end
