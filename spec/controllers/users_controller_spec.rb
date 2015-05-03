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

  describe '#update_self_intro' do
    it 'can update the self introduction of a user' do
      sign_in :user, user
      test_intro = '# my intro'
      request.env["HTTP_REFERER"] = edit_self_intro_user_path(user)
      patch :update_self_intro, id: user.id, intro: test_intro
      expect(response).to redirect_to(edit_self_intro_user_path(user))
      user.reload
      expect(user.user_detail.intro).to eq(test_intro)
      expect(user.user_detail.intro_html).to eq('<h1>my intro</h1>')
    end
  end

end