require 'spec_helper'

describe PostPolicy do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:moderator) { create(:moderator) }
  let(:post) { create(:post, author: author, board: board) }
  let(:topic) { post.topic }
  let(:new_reply) { build(:post, author: author, board: board, parent: post) }
  let(:new_post) { build(:post, author: author, board: board) }

  subject { PostPolicy }

  before(:each) { post.board.moderators << moderator }

  permissions ".scope" do
  end

  permissions :create? do
    it 'prevents creating a new reply in a locked topic' do
      topic.lock_by(admin)
      expect(subject).not_to permit(user, new_reply)
    end

    it 'prevents creating post too fast' do
      last_post = create(:post, author: author, board: board)
      expect(subject).not_to permit(author, new_post)
    end

    it 'allows creating a new post if the last post by the user was 1 minute ago' do
      last_post = create(:post, author: author, board: board, created_at: 1.minute.ago)
      expect(subject).to permit(author, new_post)
    end

    it 'prevents creating posts by a blocked user' do
      author.update(status: 1)
      expect(subject).not_to permit(author, new_post)
    end

    it 'prevents creating posts by a user blocked in the board' do
      create(:blocked_user, blockable: board, user: author, blocker: moderator)
      expect(subject).not_to permit(author, new_post)
    end
  end

  permissions :show? do
    it 'prevents showing a deleted post to users except author or moderator or admin' do
      post.delete_by(moderator)
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end

    it 'allows everyone to see a normal post' do
      expect(subject).to permit(nil, post)
      expect(subject).to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end
  end

  permissions :update? do
    it 'only allows the author to update his post' do
      expect(subject).not_to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).not_to permit(moderator, post)
      expect(subject).not_to permit(admin, post)
    end

    it 'prevents the author to update his post if he is blocked in the site' do
      author.status = 1
      expect(subject).not_to permit(author, post)
    end

    it 'prevents the author to update his post if he is blocked in the board' do
      create(:blocked_user, blockable: board, user: author, blocker: moderator)
      expect(subject).not_to permit(author, post)
    end
  end

  permissions :destroy? do
    it 'only allows author and moderator and admin to delete post' do
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end
  end

  permissions :resume? do
    it 'allows moderator and admin to resume deleted post' do
      post.delete_by(moderator)
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).not_to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end

    it 'allows author to resume post deleted by himself' do
      post.delete_by(author)
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end

    it 'prevents resuming by author who is blocked by moderator' do
      post.delete_by(author)
      create(:blocked_user, blockable: board, user: author, blocker: moderator)
      expect(subject).not_to permit(author, post)
    end

    it 'prevents resuming by author who is blocked by admin' do
      post.delete_by(author)
      author.status = 1
      author.save
      expect(subject).not_to permit(author, post)
    end
  end

  permissions :new? do
    it 'prevents creating new reply in a locked topic' do
      topic.lock_by(admin)
      expect(subject).not_to permit(user, new_reply)
    end

    it 'prevents creating posts by a blocked user' do
      author.update(status: 1)
      expect(subject).not_to permit(author, new_post)
    end

    it 'prevents creating posts by a user blocked in the board' do
      create(:blocked_user, blockable: board, user: author, blocker: moderator)
      expect(subject).not_to permit(author, new_post)
    end
  end

  permissions :set_elite? do
    it 'allows moderator and admin to set a post as elite' do
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).not_to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end
  end

  permissions :unset_elite? do
    it 'allows author and moderator and admin to unset a elite' do
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end
  end

  permissions :top_up?, :top_clear? do
    it 'allows moderator and admin to set the top status of a post' do
      expect(subject).not_to permit(nil, post)
      expect(subject).not_to permit(user, post)
      expect(subject).not_to permit(author, post)
      expect(subject).to permit(moderator, post)
      expect(subject).to permit(admin, post)
    end
  end

  permissions :comment? do
    it 'prevents creating comments by a blocked user' do
      user.update(status: 1)
      expect(subject).not_to permit(user, post)
    end

    it 'prevents creating comments by a user blocked in the board' do
      create(:blocked_user, blockable: board, user: user, blocker: moderator)
      expect(subject).not_to permit(user, post)
    end

    it 'prevents creating comment too fast' do
      comment = create(:comment, user: user, commentable: post)
      expect(subject).not_to permit(user, post)
    end

    it 'allows creating a new comment if the last comment by the user was 5 seconds ago' do
      comment = create(:comment, user: user, commentable: post, created_at: 5.seconds.ago)
      expect(subject).to permit(user, post)
    end
  end
end
