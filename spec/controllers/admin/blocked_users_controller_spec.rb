require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::BlockedUsersController, type: :controller do
  include_context 'all roles'

  describe '#index' do
    it_behaves_like 'for admin and moderator', 'index'
  end

  describe '#create' do
    before do
      @new_blocked_user_info = {
          user_id: another_user.id,
          blockable_type: 'Board',
          blockable_id: board.id
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      post :create, blocked_user: @new_blocked_user_info
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      post :create, blocked_user: @new_blocked_user_info
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      post :create, blocked_user: @new_blocked_user_info
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#destroy' do
    before do
      @blocked_user = create(:blocked_user, user: another_user, blocker: moderator, blockable: board)
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      delete :destroy, id: @blocked_user.id
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      delete :destroy, id: @blocked_user.id
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      request.env["HTTP_REFERER"] = admin_blocked_users_path
      delete :destroy, id: @blocked_user.id
      expect(response).to redirect_to(admin_blocked_users_path)
      expect(request.flash[:error]).not_to be_blank
    end
  end

end