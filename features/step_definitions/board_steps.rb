Given(/^a board with name "(.*?)"$/) do |name|
  @board = create(:board, name: name)
end

When(/^I click the link with id "(.*?)" on the page of the board$/) do |link_id|
  visit board_path(@board)
  click_link link_id
end

And(/^I have favored the board$/) do
  @me.favorites << @board
end

Then(/^I would favor the board$/) do
  visit root_path
  expect(find('#favorite boards')).to have_link(@board.name)
end

Then(/^I would disfavor the board$/) do
  visit root_path
  expect(find('#favorite boards')).not_to have_link(@board.name)
end