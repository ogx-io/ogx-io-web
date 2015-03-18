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