require 'rails_helper'

RSpec.describe Elite::PostsController, type: :controller do

  let(:root_category) { create(:elite_category) }
  let(:admin) { create(:user, :admin) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:another_user) { create(:user) }
  let(:board) { create(:board) }
  let(:old_post) { create(:post, author: author, board: board) }
  let(:elite_post) do
    Elite::Post.add_post(old_post, moderator)
    Elite::Post.find_by(original_id: old_post.id)
  end

  before do
    board.moderators << moderator
  end

  describe '#show' do
    context 'elite post is deleted?' do
      before do
        elite_post.delete_by(moderator)
      end

      it 'succeeds when the current user is author' do
        sign_in :user, author
        get :show, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        get :show, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        get :show, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        get :show, id: elite_post.id
        expect(response).to redirect_to(root_path)
        expect(request.flash[:error]).not_to be_blank
      end

      it 'fails when user not signed in' do
        get :show, id: elite_post.id
        expect(response).to redirect_to(root_path)
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'elite post is normal' do
      it 'succeeds' do
        get :show, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end
    end
  end

  describe '#destroy' do
    context 'user signed in' do
      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :delete, :destroy, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :delete, :destroy, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :delete, :destroy, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :delete, :destroy, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'user not signed in' do
      it 'fails' do
        xhr :delete, :destroy, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#resume' do
    context 'elite post is deleted by author' do
      before do
        elite_post.delete_by(author)
      end

      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'fails when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end

      it 'fails when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'elite post is deleted by moderator' do
      before do
        elite_post.delete_by(moderator)
      end

      it 'fails when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end
    end

    context 'user not signed in' do
      it 'fails' do
        xhr :patch, :resume, id: elite_post.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end
end