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

Then(/^I should see the post$/) do
  expect(page).to have_content(@post.title)
end

And(/^there is a post written by me$/) do
  @post = create(:post, author: @me)
end

And(/^the post is deleted by me$/) do
  @post.delete_by(@me)
end

And(/^(you|I) would not see the post$/) do |who|
  visit post_path(@post)
  expect(page).not_to have_content(@post.title)
end

And(/^there is a moderator of the board that the post belongs to$/) do
  @moderator = create(:user)
  @post.board.moderators << @moderator
end

And(/^the post is deleted by the moderator$/) do
  @post.delete_by(@moderator)
end

And(/^I click the reply link of the post of the (\d+)th floor$/) do |n|
  @post = @topic.posts[n.to_i]
  visit show_topic_post_path(@topic.id, @post.id)
  within("#post-#{@post.id}-container") do
    click_link I18n.t('action.reply')
    find('.reply-container')
  end
end

Then(/^the reply form should appear$/) do
  within("#post-#{@post.id}-container") do
    find('.reply-container')
  end
end

And(/^I input "(.*?)" into the textarea$/) do |content|
  @posted_content = content
  within("#post-#{@post.id}-container") do
    fill_in 'post_body', with: content
  end
end

And(/^I click the submit button of the reply form$/) do
  within("#post-#{@post.id}-container") do
    click_button I18n.t('action.post')
  end
end

Then(/^the new reply post should appear below the replied post$/) do
  find("#floor-#{@topic.posts.count}")
  expect(page).to have_content(@posted_content)
end