require 'rails_helper'

RSpec.describe Admin::Elite::CategoriesController, type: :controller do
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

  before do
    board.moderators << moderator
  end

  describe '#new' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :new, parent_id: root_category.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      get :new, parent_id: root_category.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      get :new, parent_id: root_category.id
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#edit' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :edit, id: child2.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      get :edit, id: child2.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is a normal user' do
      sign_in :user, another_user
      get :edit, id: child2.id
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#create' do
    before do
      @new_category_info = {
          title: 'new category',
          parent_id: root_category.id
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      old_count = root_category.children.count
      post :create, elite_category: @new_category_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      expect(request.flash[:error]).to be_blank
      root_category.reload
      expect(root_category.children.count).to eq(old_count + 1)
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      old_count = root_category.children.count
      post :create, elite_category: @new_category_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      expect(request.flash[:error]).to be_blank
      root_category.reload
      expect(root_category.children.count).to eq(old_count + 1)
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      old_count = root_category.children.count
      post :create, elite_category: @new_category_info
      expect(response).not_to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      expect(request.flash[:error]).not_to be_blank
      root_category.reload
      expect(root_category.children.count).to eq(old_count)
    end
  end

  describe '#update' do
    before do
      @new_category_info = {
          title: 'new category',
          parent_id: root_category.id
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      patch :update, id: child2.id, elite_category: @new_category_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      child2.reload
      expect(child2.title).to eq(@new_category_info[:title])
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      patch :update, id: child2.id, elite_category: @new_category_info
      expect(response).to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      child2.reload
      expect(child2.title).to eq(@new_category_info[:title])
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      patch :update, id: child2.id, elite_category: @new_category_info
      expect(response).not_to redirect_to(admin_elite_nodes_path(parent_id: root_category.id))
      child2.reload
      expect(child2.title).not_to eq(@new_category_info[:title])
    end
  end
end