Given(/^a board with name "(.*?)"$/) do |name|
  @board = create(:board, name: name)
end

When(/^I click the link with id "(.*?)" on the page of the board$/) do |link_id|
  visit board_path(@board)
  click_link link_id
end

And(/^I have favored the board$/) do
  @me.add_favorite(@board)
end

Then(/^I would favor the board$/) do
  visit root_path
  expect(find('.favorite-board-list')).to have_link(@board.name)
end

Then(/^I would disfavor the board$/) do
  visit root_path
  expect(find('.favorite-board-list')).not_to have_link(@board.name)
end

Given(/^there is a category with name "(.*?)" and path "(.*?)"$/) do |name, path|
  @category = create(:category, name: name, path: path)
end

And(/^there is a child board with name "(.*?)" and path "(.*?)"$/) do |name, path|
  @board = create(:board, name: name, path: path, parent: @category)
end

Then(/^you should see the board "(.*?)"$/) do |name|
  expect(find('.board-main')).to have_content(name)
end

And(/^there is a child category with name "(.*?)" and path "(.*?)"$/) do |name, path|
  @child_category = create(:category, name: name, path: path, parent: @category)
end

Then(/^you should see the category "(.*?)"$/) do |name|
  expect(find('.show-category')).to have_content(name)
end