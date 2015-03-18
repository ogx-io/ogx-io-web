Given(/^there is a post$/) do
  @post = create(:post)
end

And(/^I visit the post$/) do
  visit post_path(@post)
end

And(/^I click the link with id "(.*?)" for the post and wait for "(.*?)"$/) do |link_id, next_link_id|
  click_link link_id
  find("##{next_link_id}")
end

Then(/^the like count of the post should be (\d+)$/) do |count|
  @post.reload
  expect(@post.likes.count).to eq(count.to_i)
end