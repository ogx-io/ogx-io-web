require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:another_user) { create(:user) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:board) { create(:board, moderators: [moderator]) }
  let(:old_post) { create(:post, author: author, board: board) }
  let(:topic) { old_post.topic }
  let(:new_comment) { create(:comment, body: 'test comment', commentable: old_post, user: author) }

  describe '#create' do
    context 'user signed in' do
      before do
        sign_in :user, another_user
        @new_comment_info = {
            body: 'new comment',
            commentable_type: 'Post',
            commentable_id: old_post.id
        }
      end
      it 'succeeds when the current user is a normal user' do
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).to be_blank
        expect(old_post.comments.count).to eq(1)
      end

      it 'fails if the current user is blocked by moderator' do
        create(:blocked_user, user: another_user, blocker: moderator, blockable: board)
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.count).to eq(0)
      end

      it 'fails if the current user is blocked by admin' do
        another_user.update(status: 1)
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.count).to eq(0)
      end

      it 'can not create new comments too fast' do
        create(:comment, body: 'test comment', commentable: old_post, user: another_user)
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.count).to eq(1)
      end

      it 'can create new comments in 5 seconds' do
        create(:comment, body: 'test comment', commentable: old_post, user: another_user, created_at: 5.seconds.ago)
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).to be_blank
        expect(old_post.comments.count).to eq(2)
      end
    end

    context 'user not signed in' do
      before do
        @new_comment_info = {
            body: 'new comment',
            commentable_type: 'Post',
            commentable_id: old_post.id
        }
      end

      it 'fails' do
        xhr :post, :create, comment: @new_comment_info
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.count).to eq(0)
      end
    end
  end

  describe '#destroy' do
    context 'user signed in' do
      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :delete, :destroy, id: new_comment.id
        expect(request.flash[:error]).to be_blank
        expect(old_post.comments.normal.count).to eq(0)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :delete, :destroy, id: new_comment.id
        expect(request.flash[:error]).to be_blank
        expect(old_post.comments.normal.count).to eq(0)
      end

      it 'fails if the current user is another user' do
        sign_in :user, another_user
        xhr :delete, :destroy, id: new_comment.id
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.normal.count).to eq(1)
      end
    end

    context 'user not signed in' do
      it 'fails' do
        xhr :delete, :destroy, id: new_comment.id
        expect(request.flash[:error]).not_to be_blank
        expect(old_post.comments.normal.count).to eq(1)
      end
    end
  end

end