require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:another_user) { create(:user) }
  let(:root_category) { create(:category) }
  let(:brother1) { create(:category) }
  let(:brother2) { create(:category) }
  let(:child1) { create(:category, parent: root_category) }
  let(:child2) { create(:category, parent: root_category) }
  let(:board1) { create(:board, parent: root_category) }
  let(:board2) { create(:board, parent: child1) }

  describe '#new' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      get :new
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      get :new
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

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      get :edit, id: child2.id
      expect(response).not_to be_success
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#create' do
    before do
      @new_category_info = {
          name: 'new cate',
          path: 'new_cate',
          parent_id: child2.id
      }
    end

    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      post :create, category: @new_category_info
      expect(response).to redirect_to(admin_nodes_path(parent_id: child2.id))
      expect(request.flash[:error]).to be_blank
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      post :create, category: @new_category_info
      expect(response).not_to redirect_to(admin_nodes_path(parent_id: child2.id))
      expect(request.flash[:error]).not_to be_blank
    end
  end

  describe '#update' do
    before do
      @new_category_info = {
          name: 'new cate',
          path: 'new_cate',
          parent_id: child2.id
      }
    end

    context 'not using ajax' do
      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        patch :update, id: child1.id, category: @new_category_info
        expect(response).to redirect_to(admin_nodes_path(parent_id: child2.id))
        expect(request.flash[:error]).to be_blank
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        patch :update, id: child1.id, category: @new_category_info
        expect(response).not_to redirect_to(admin_nodes_path(parent_id: child2.id))
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'using ajax' do
      it 'succeeds when the current user is admin' do
        sign_in :user, admin
        xhr :patch, :update, id: child1.id, category: @new_category_info
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :update, id: child1.id, category: @new_category_info
        expect(response).to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end
end