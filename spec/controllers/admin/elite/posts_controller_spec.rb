require 'rails_helper'
require 'controllers/admin/test_helpers'

RSpec.describe Admin::Elite::PostsController, type: :controller do
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

  describe '#edit' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :edit, id: elite_post.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      get :edit, id: elite_post.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      get :edit, id: elite_post.id
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#update' do
    before do
      @new_elite_post_info = {
          parent_id: child2.id
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      patch :update, id: elite_post.id, elite_post: @new_elite_post_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: child2.id))
      elite_post.reload
      expect(elite_post.parent_id).to eq(child2.id)
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      patch :update, id: elite_post.id, elite_post: @new_elite_post_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: child2.id))
      elite_post.reload
      expect(elite_post.parent_id).to eq(child2.id)
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      patch :update, id: elite_post.id, elite_post: @new_elite_post_info
      expect(response).not_to redirect_to(admin_elite_nodes_path(parent_id: child2.id))
      elite_post.reload
      expect(elite_post.parent_id).not_to eq(child2.id)
    end
  end
end