require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::NodesController, type: :controller do
  include_context 'all roles'

  describe '#index' do
    it_behaves_like 'only for admin', 'index'
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