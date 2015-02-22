require 'rails_helper'

RSpec.describe Post, :type => :model do

  let (:user) { create(:user) }
  let (:user1) { create(:user) }
  let (:user2) { create(:user) }
  let (:post) { create(:post, board: board, author: user) }
  let (:topic) { post.topic }
  let (:board) { create(:board) }
  let (:moderator) { create(:moderator, managing_boards: [board]) }
  let (:reply1) { create(:post, topic: post.topic, parent: post, board: post.board, author: post.author) }
  let (:reply2) { create(:post, topic: post.topic, parent: reply1, board: post.board, author: post.author) }

  it 'creates a new topic if not replying' do
    expect(post.topic.nil?).to be_falsey
  end

  it 'has a proper floor number' do
    expect(reply1.floor).to eq(1)
    expect(reply2.floor).to eq(2)
  end

  it 'can be softly deleted and resumed by author or admin' do
    post.delete_by(user)
    expect(post.deleted?).to be_truthy
    expect(post.deleted).to eq(1)
    expect(post.deleter).to eq(user)

    post.resume_by(user)
    expect(post.deleted?).to be_falsey
    expect(post.deleted).to eq(0)
    expect(post.resumer).to eq(user)

    post.delete_by(moderator)
    expect(post.deleted?).to be_truthy
    expect(post.deleted).to eq(2)
    expect(post.deleter).to eq(moderator)
  end

  it 'deletes the topic when it is deleted as the last post of the topic' do
    post.delete_by(user)
    reply1.delete_by(user)
    reply2.delete_by(user)

    expect(topic.deleted?).to be_truthy
    expect(topic.deleter).to eq(user)
  end

  it 'mentions the author if his post is replied by the other' do
    post = create(:post, author: user1)
    reply = create(:post, author: user2, topic: post.topic, parent: post)
    user1.reload
    expect(user1.notifications.count).to eq(1)
    expect(user1.notifications[0].class).to eq(Notification::PostReply)
    expect(user1.notifications[0].post).to eq(reply)
  end

  it 'mentions somebody if the author @ him in the content' do
    post = create(:post, author: user1, body: "hi @#{ user2.name }")
    user2.reload # must call the reload method after sending mention notification or user2.notifications would not contain the right values
    expect(user2.notifications.count).to eq(1)
    expect(user2.notifications[0].class).to eq(Notification::Mention)
  end

  it 'turns the mentioned user in the content into link' do
    post = create(:post, author: user1, body: "hi @#{ user2.name }")
    expect(post.body_html).to have_tag('a', text: "@#{ user2.name }", href: "/#{ user2.name }")
  end

end
