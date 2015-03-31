Given(/^there is a new topic$/) do
  post = create(:post)
  @topic = post.topic
end

When(/^visit the topic$/) do
  visit topic_path(@topic)
end

Then(/^the click count of the topic should be (\d+)$/) do |count|
  expect(find('.topic-click-count')).to have_content(I18n.t('topics.click_count', count: count))
end

And(/^visit the topic on the page (\d+)$/) do |page|
  visit topic_path(@topic, page: 2)
end

Given(/^there is a topic with (\d+) replies$/) do |n|
  post = create(:post)
  @topic = post.topic
  n.to_i.times.collect { |i| create :post, topic: @topic, parent: post, board: @topic.board }
end

And(/^there are some comments in some of the replies of the topic$/) do
  @posts = [@topic.posts[0], @topic.posts[2], @topic.posts[3]]
  @comments = []
  @posts.each do |post|
    @comments.push create(:comment, commentable: post, board: post.board)
  end
end

And(/^I am the moderator of the board of the topic$/) do
  @topic.board.moderators << @me
end

And(/^I click the "move" link of the topic$/) do
  visit topic_path(@topic)
  first(:link, I18n.t('action.change_board')).click
end

Then(/^I should see the form for moving the topic$/) do
  find('#change_board_form')
end

And(/^submit the new board id that the topic is changing to$/) do
  @new_board = create(:board)
  fill_in 'topic_board_id', with: @new_board.id
  click_button I18n.t('action.submit')
end

Then(/^the topic and its posts and comments should be changed to the new board$/) do
  @topic.reload
  expect(@topic.board).to eq(@new_board)
  @posts.each do |post|
    post.reload
    expect(post.board).to eq(@new_board)
  end
  @comments.each do |comment|
    comment.reload
    expect(comment.board).to eq(@new_board)
  end
end