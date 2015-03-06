require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::PostsController, type: :controller do
  include_context 'all roles'

  describe '#index' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :index
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      get :index
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      get :index
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#destroy' do
    it 'succeeds if the current user is moderator' do
      sign_in :user, moderator
      xhr :delete, :destroy, id: old_post.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
      old_post.reload
      expect(old_post.deleted).to eq(2)
    end

    it 'succeeds if the current user is admin' do
      sign_in :user, admin
      xhr :delete, :destroy, id: old_post.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
      old_post.reload
      expect(old_post.deleted).to eq(2)
    end

    it 'fails if the current user is another user' do
      sign_in :user, another_user
      xhr :delete, :destroy, id: old_post.id
      expect(response).to be_success
      expect(request.flash[:error]).not_to be_blank
      old_post.reload
      expect(old_post.deleted).to eq(0)
    end
  end

  describe '#resume' do
    context 'post deleted by author' do
      before do
        old_post.delete_by(author)
      end

      it 'fails if the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end

      it 'fails if the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end

      it 'succeeds if the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(0)
      end

      it 'fails if the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end
    end

    context 'post deleted by moderator' do
      before do
        old_post.delete_by(moderator)
      end

      it 'succeeds if the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(0)
      end

      it 'succeeds if the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(0)
      end

      it 'fails if the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(2)
      end

      it 'fails if the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: old_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.deleted).to eq(2)
      end
    end
  end
end