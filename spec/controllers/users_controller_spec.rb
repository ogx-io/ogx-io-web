require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:board) { create(:board) }

  before do
    10.times { create(:post, author: user, board: board) }
  end

  describe '#show' do
    it 'succeeds' do
      get :show, id: user.id
      expect(response).to be_success
    end

    it '404 if user is missing' do
      expect {
        get :show, id: 0
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe '#topics' do
    it 'succeeds' do
      get :topics, id: user.id
      expect(response).to be_success
    end

    it '404 if user is missing' do
      expect {
        get :topics, id: 0
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe '#posts' do
    context 'user signed in' do
      before do
        sign_in :user, user
      end

      it 'succeeds' do
        get :posts, id: user.id
        expect(response).to be_success
      end

      it '404 if user is missing' do
        expect {
          get :posts, id: 0
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'user not signed in' do
      it 'succeeds' do
        get :posts, id: user.id
        expect(response).to be_success
      end

      it '404 if user is missing' do
        expect {
          get :posts, id: 0
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

  describe '#elites' do
    context 'user signed in' do
      before do
        sign_in :user, user
      end

      it 'succeeds' do
        get :elites, id: user.id
        expect(response).to be_success
      end

      it '404 if user is missing' do
        expect {
          get :elites, id: 0
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'user not signed in' do
      it 'succeeds' do
        get :elites, id: user.id
        expect(response).to be_success
      end

      it '404 if user is missing' do
        expect {
          get :elites, id: 0
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

end