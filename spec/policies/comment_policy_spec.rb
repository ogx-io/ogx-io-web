require 'spec_helper'

describe CommentPolicy do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:moderator) { create(:moderator) }
  let(:post) { create(:post, author: author, board: board) }
  let(:comment) { create(:comment, user: author, commentable: post) }

  subject { CommentPolicy }

  before(:each) { post.board.moderators << moderator }

  permissions :destroy? do
    it 'allows moderator and admin and author to delete comment' do
      expect(subject).not_to permit(nil, comment)
      expect(subject).not_to permit(user, comment)
      expect(subject).to permit(author, comment)
      expect(subject).to permit(moderator, comment)
      expect(subject).to permit(admin, comment)
    end
  end

  permissions :resume? do
    it 'allow moderator and admin to resume the comment deleted by them' do
      comment.delete_by(moderator)
      expect(subject).not_to permit(nil, comment)
      expect(subject).not_to permit(user, comment)
      expect(subject).not_to permit(author, comment)
      expect(subject).to permit(moderator, comment)
      expect(subject).to permit(admin, comment)
    end

    it 'allow author to resume the comment deleted by himself' do
      comment.delete_by(author)
      expect(subject).not_to permit(nil, comment)
      expect(subject).not_to permit(user, comment)
      expect(subject).to permit(author, comment)
      expect(subject).not_to permit(moderator, comment)
      expect(subject).not_to permit(admin, comment)
    end
  end
end
