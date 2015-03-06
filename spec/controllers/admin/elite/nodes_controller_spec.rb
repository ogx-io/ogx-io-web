require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::Elite::NodesController, type: :controller do
  include_context 'all roles'

  let(:root_category) { create(:elite_category, board: board) }
  let(:brother1) { create(:elite_category, board: board) }
  let(:brother2) { create(:elite_category, board: board) }
  let(:child1) { create(:elite_category, parent: root_category, board: board) }
  let(:child2) { create(:elite_category, parent: root_category, board: board) }
  let(:elite_post) do
    Elite::Post.add_post(old_post, moderator)
    Elite::Post.find_by(original_id: old_post.id)
  end

  describe '#index' do
    it_behaves_like 'for admin and moderator', 'index'
  end

  shared_examples 'fails to change order' do |direction, user_type|
    it "for #{user_type}" do
      sign_in :user, test_user
      request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: node.parent_id)
      patch "order_#{direction}", id: node.id
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: node.parent_id))
      expect(request.flash[:error]).not_to be_blank
      node.reload
      expect(node.order).to eq(0)
    end
  end

  shared_examples 'succeeds to change order' do |direction, user_type|
    it "for #{user_type}" do
      sign_in :user, test_user
      request.env["HTTP_REFERER"] = admin_elite_nodes_path(parent_id: node.parent_id)
      patch "order_#{direction}", id: node.id
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: node.parent_id))
      expect(request.flash[:error]).to be_blank
      node.reload
      expect(node.order).to eq(direction == 'up' ? 1 : -1)
    end
  end

  describe '#order_up' do
    context 'elite post' do
      it_behaves_like 'succeeds to change order', 'up', 'admin' do
        let(:test_user) { admin }
        let(:node) { elite_post }
      end

      it_behaves_like 'succeeds to change order', 'up', 'moderator' do
        let(:test_user) { moderator }
        let(:node) { elite_post }
      end

      it_behaves_like 'fails to change order', 'up', 'another user' do
        let(:test_user) { another_user }
        let(:node) { elite_post }
      end
    end

    context 'elite category' do
      it_behaves_like 'succeeds to change order', 'up', 'admin' do
        let(:test_user) { admin }
        let(:node) { child2 }
      end

      it_behaves_like 'succeeds to change order', 'up', 'moderator' do
        let(:test_user) { moderator }
        let(:node) { child2 }
      end

      it_behaves_like 'fails to change order', 'up', 'another user' do
        let(:test_user) { another_user }
        let(:node) { child2 }
      end
    end
  end

  describe '#order_down' do
    context 'elite post' do
      it_behaves_like 'succeeds to change order', 'down', 'admin' do
        let(:test_user) { admin }
        let(:node) { elite_post }
      end

      it_behaves_like 'succeeds to change order', 'down', 'moderator' do
        let(:test_user) { moderator }
        let(:node) { elite_post }
      end

      it_behaves_like 'fails to change order', 'down', 'another user' do
        let(:test_user) { another_user }
        let(:node) { elite_post }
      end
    end

    context 'elite category' do
      it_behaves_like 'succeeds to change order', 'down', 'admin' do
        let(:test_user) { admin }
        let(:node) { child2 }
      end

      it_behaves_like 'succeeds to change order', 'down', 'moderator' do
        let(:test_user) { moderator }
        let(:node) { child2 }
      end

      it_behaves_like 'fails to change order', 'down', 'another user' do
        let(:test_user) { another_user }
        let(:node) { child2 }
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