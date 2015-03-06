require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::CommentsController, type: :controller do
  include_context 'all roles'
  let(:comment) { create(:comment, commentable: old_post, user: author) }

  describe '#index' do
    it_behaves_like 'for admin and moderator', 'index'
  end

  describe '#destroy' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      xhr :delete, :destroy, id: comment.id
      expect(response).to render_template('admin/comments/refresh')
      expect(request.flash[:error]).to be_blank
      comment.reload
      expect(comment.deleted).to eq(2)
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      xhr :delete, :destroy, id: comment.id
      expect(response).to render_template('admin/comments/refresh')
      expect(request.flash[:error]).to be_blank
      comment.reload
      expect(comment.deleted).to eq(2)
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      xhr :delete, :destroy, id: comment.id
      expect(response).not_to render_template('admin/comments/refresh')
      expect(request.flash[:error]).not_to be_blank
      comment.reload
      expect(comment.deleted).to eq(0)
    end
  end

  describe '#resume' do
    context 'comment deleted by author' do
      before do
        comment.delete_by(author)
      end

      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: comment.id
        expect(response).to render_template('admin/comments/refresh')
        expect(request.flash[:error]).to be_blank
        comment.reload
        expect(comment.deleted).to eq(0)
      end

      it 'fails when the current user is author but who is blocked by admin' do
        sign_in :user, author
        author.update(status: 1)
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(1)
      end

      it 'fails when the current user is author but who is blocked by moderator' do
        sign_in :user, author
        create(:blocked_user, user: author, blocker: moderator, blockable: board)
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(1)
      end

      it 'fails when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(1)
      end

      it 'fails when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(1)
      end
    end

    context 'comment deleted by moderator' do
      before do
        comment.delete_by(moderator)
      end

      it 'fails when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(2)
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: comment.id
        expect(response).to render_template('admin/comments/refresh')
        expect(request.flash[:error]).to be_blank
        comment.reload
        expect(comment.deleted).to eq(0)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: comment.id
        expect(response).to render_template('admin/comments/refresh')
        expect(request.flash[:error]).to be_blank
        comment.reload
        expect(comment.deleted).to eq(0)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: comment.id
        expect(response).not_to render_template('admin/comments/refresh')
        expect(request.flash[:error]).not_to be_blank
        comment.reload
        expect(comment.deleted).to eq(2)
      end
    end
  end


end