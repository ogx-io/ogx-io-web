require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user) }
  let(:board) { create(:board) }

  before do
    board.moderators << moderator
  end

  describe '#index' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :index
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is moderator' do
      sign_in :user, moderator
      get :index
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, user
      get :index
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#update' do
    before do
      @new_user_info = {
          status: 1
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      xhr :post, :update, id: user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is moderator' do
      sign_in :user, moderator
      xhr :post, :update, id: user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).not_to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, user
      xhr :post, :update, id: user.id, user: @new_user_info
      expect(response).to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end
end