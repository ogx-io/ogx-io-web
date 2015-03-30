require 'rails_helper'

RSpec.describe Topic, :type => :model do

  let (:user) { create(:user) }
  let (:post) { create(:post, board: board, author: user) }
  let (:comment) { create(:comment, user: user, commentable: post, board: board)}
  let (:topic) { post.topic }
  let (:board) { create(:board) }
  let (:another_board) { create(:board) }
  let (:moderator) { create(:moderator, managing_boards: [board]) }

  it 'updates the replied_at field after a new reply occurs' do
    reply1 = create(:post, topic: post.topic, parent: post)
    reply2 = create(:post, topic: post.topic, parent: reply1)
    expect(topic.replied_at).to eq(reply2.created_at)
  end

  it 'can be softly deleted and resumed by author or admin' do
    topic.delete_by(user)
    expect(topic.deleted?).to be_truthy
    expect(topic.deleted).to eq(1)
    expect(topic.deleter).to eq(user)

    topic.resume_by(user)
    expect(topic.deleted?).to be_falsey
    expect(topic.deleted).to eq(0)
    expect(topic.resumer).to eq(user)

    topic.delete_by(moderator)
    expect(topic.deleted?).to be_truthy
    expect(topic.deleted).to eq(2)
    expect(topic.deleter).to eq(moderator)
  end

  it 'can be moved to another board' do
    comment
    topic.move_to_board(another_board.id)
    topic.reload
    expect(topic.board).to eq(another_board)
    expect(post.board).to eq(another_board)
    expect(comment.board).to eq(another_board)
  end

end
