require 'rails_helper'

RSpec.describe Post, :type => :model do

  it 'should create a new topic if not replying' do
    post = create(:post)
    expect(post.topic.nil?).to be_falsey
  end

  it 'should have a proper floor number' do
    post = create(:post)
    reply1 = create(:post, topic: post.topic, parent: post, board: post.board, author: post.author)
    reply2 = create(:post, topic: post.topic, parent: reply1, board: post.board, author: post.author)
    expect(reply1.floor).to eq(1)
    expect(reply2.floor).to eq(2)
  end

  it 'should be softly deleted and resumed by author or admin' do
    board = create(:board)
    user = create(:user)
    moderator = create(:moderator)
    board.moderators << moderator
    post = create(:post, board: board, author: user)

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

  it 'should delete the topic when it is deleted as the last post of the topic' do
    board = create(:board)
    user = create(:user)
    post = create(:post, board: board, author: user)
    topic = post.topic
    reply1 = create(:post, topic: post.topic, parent: post, board: post.board, author: post.author)
    reply2 = create(:post, topic: post.topic, parent: reply1, board: post.board, author: post.author)

    post.delete_by(user)
    reply1.delete_by(user)
    reply2.delete_by(user)

    expect(topic.deleted?).to be_truthy
    expect(topic.deleter).to eq(user)
  end

end
