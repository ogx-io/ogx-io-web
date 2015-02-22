require 'rails_helper'

RSpec.describe Comment, :type => :model do

  let (:user) { create(:user) }
  let (:user1) { create(:user) }
  let (:user2) { create(:user) }
  let (:post) { create(:post, board: board, author: user) }
  let (:comment) { create(:comment, user: user, commentable: post, board: board)}
  let (:topic) { post.topic }
  let (:board) { create(:board) }
  let (:moderator) { create(:moderator, managing_boards: [board]) }

  it "send notification to the author of the commenting object after create a comment" do
    expect(comment.commentable.author.notifications.count).to eq(0)
    comment2 = create(:comment, user: user1, commentable: post, board: board)
    comment3 = create(:comment, user: user2, commentable: post, board: board)
    user.reload
    expect(user.notifications.count).to eq(2)
    expect(user.notifications[0].class).to eq(Notification::Comment)
  end

  it 'can be softly deleted and resumed by author or admin' do
    comment.delete_by(user)
    expect(comment.deleted?).to be_truthy
    expect(comment.deleted).to eq(1)
    expect(comment.deleter).to eq(user)

    comment.resume_by(user)
    expect(comment.deleted?).to be_falsey
    expect(comment.deleted).to eq(0)
    expect(comment.resumer).to eq(user)

    comment.delete_by(moderator)
    expect(comment.deleted?).to be_truthy
    expect(comment.deleted).to eq(2)
    expect(comment.deleter).to eq(moderator)
  end

  it 'mentions somebody if the author @ him in the content' do
    comment = create(:comment, user: user1, body: "hi @#{ user2.name }")
    user2.reload
    expect(user2.notifications.count).to eq(1)
    expect(user2.notifications[0].class).to eq(Notification::Mention)
  end

  it 'turns the mentioned user in the content into link' do
    comment = create(:comment, user: user1, body: "hi @#{ user2.name }")
    expect(comment.body_html).to have_tag('a', text: "@#{ user2.name }", href: "/#{ user2.name }")
  end
end
