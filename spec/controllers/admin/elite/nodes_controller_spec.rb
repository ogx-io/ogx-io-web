require 'rails_helper'

RSpec.describe Admin::Elite::NodesController, type: :controller do
  let(:root_category) { create(:elite_category, board: board) }
  let(:brother1) { create(:elite_category, board: board) }
  let(:brother2) { create(:elite_category, board: board) }
  let(:child1) { create(:elite_category, parent: root_category, board: board) }
  let(:child2) { create(:elite_category, parent: root_category, board: board) }
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

  describe '#index' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :index, board_id: board.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      get :index, board_id: board.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      get :index, board_id: board.id
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#order_up' do
    context 'elite post' do
      before do
        @node = elite_post
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(1)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.order).to eq(0)
      end
    end

    context 'elite category' do
      before do
        @node = child2
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(1)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_up, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.order).to eq(0)
      end
    end
  end

  describe '#order_down' do
    context 'elite post' do
      before do
        @node = elite_post
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(-1)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(-1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.order).to eq(0)
      end
    end

    context 'elite category' do
      before do
        @node = child2
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(-1)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.order).to eq(-1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: @node.parent_id)
        patch :order_down, id: @node.id
        expect(response).to redirect_to(admin_elite_nodes_path(parent_id: @node.parent_id))
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.order).to eq(0)
      end
    end
  end

  describe '#destroy' do
    context 'elite post' do
      before do
        @node = elite_post
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end
    end

    context 'elite category' do
      before do
        @node = child2
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :delete, :destroy, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end
    end
  end

  describe '#resume' do
    context 'elite post deleted by author' do
      before do
        @node = elite_post
        @node.delete_by(author)
      end

      it 'fails when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(1)
      end

      it 'fails when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(1)
      end

      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(1)
      end
    end

    context 'elite post deleted by moderator' do
      before do
        @node = elite_post
        @node.delete_by(moderator)
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end

      it 'fails when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end
    end

    context 'elite category' do
      before do
        @node = child2
        @node.delete_by(moderator)
      end

      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
        @node.reload
        expect(@node.deleted).to eq(0)
      end

      it 'fails when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: @node.id
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
        @node.reload
        expect(@node.deleted).to eq(2)
      end
    end
  end

end