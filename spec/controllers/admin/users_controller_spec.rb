require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::UsersController, type: :controller do
  include_context 'all roles'

  describe '#index' do
    it_behaves_like 'only for admin', 'index'
  end

  describe '#update' do
    before do
      @new_user_info = {
          status: 1
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      xhr :post, :update, id: another_user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is moderator' do
      sign_in :user, moderator
      xhr :post, :update, id: another_user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).not_to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      xhr :post, :update, id: another_user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end
end