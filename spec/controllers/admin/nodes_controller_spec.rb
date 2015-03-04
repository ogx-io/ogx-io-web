require 'rails_helper'

RSpec.describe Admin::NodesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:another_user) { create(:user) }
  let(:author) { create(:user) }
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
      sign_in :user, another_user
      get :index
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#order_up' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      request.env["HTTP_REFERER"] = admin_nodes_path
      patch :order_up, id: board.id
      expect(request.flash[:error]).to be_blank
      expect(response).to redirect_to(admin_nodes_path)
      board.reload
      expect(board.order).to eq(1)
    end

    it 'fails when the current user is not admin' do
      sign_in :user, another_user
      request.env["HTTP_REFERER"] = admin_nodes_path
      patch :order_up, id: board.id
      expect(request.flash[:error]).not_to be_blank
      expect(response).to redirect_to(admin_nodes_path)
      board.reload
      expect(board.order).to eq(0)
    end
  end

  describe '#order_down' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      request.env["HTTP_REFERER"] = admin_nodes_path
      patch :order_down, id: board.id
      expect(request.flash[:error]).to be_blank
      expect(response).to redirect_to(admin_nodes_path)
      board.reload
      expect(board.order).to eq(-1)
    end

    it 'fails when the current user is not admin' do
      sign_in :user, another_user
      request.env["HTTP_REFERER"] = admin_nodes_path
      patch :order_down, id: board.id
      expect(request.flash[:error]).not_to be_blank
      expect(response).to redirect_to(admin_nodes_path)
      board.reload
      expect(board.order).to eq(0)
    end
  end
end