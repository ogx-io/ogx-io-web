require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:board) { create(:board) }

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

  describe '#collect_board' do
    context 'user signed in' do
      before do
        sign_in :user, user
      end

      it 'succeeds' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :collect_board, id: user.id, board_id: board.id
        expect(response).to redirect_to(board_path(board))
        user.reload
        expect(user.collecting_boards).to include(board)
      end

      it 'fails if not the current user' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :collect_board, id: other_user.id, board_id: board.id
        expect(response).to redirect_to(board_path(board))
        other_user.reload
        expect(other_user.collecting_boards).not_to include(board)
      end
    end

    context 'user not signed in' do
      it 'fails' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :collect_board, id: user.id, board_id: board.id
        expect(response).to redirect_to(new_user_session_path)
        user.reload
        expect(user.collecting_boards).not_to include(board)
      end
    end
  end

  describe '#uncollect_board' do
    before do
      user.collecting_boards << board
      other_user.collecting_boards << board
    end

    context 'user signed in' do
      before do
        sign_in :user, user
      end

      it 'succeeds' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :uncollect_board, id: user.id, board_id: board.id
        expect(response).to redirect_to(board_path(board))
        user.reload
        expect(user.collecting_boards).not_to include(board)
      end

      it 'fails if not the current user' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :uncollect_board, id: other_user.id, board_id: board.id
        expect(response).to redirect_to(board_path(board))
        other_user.reload
        expect(other_user.collecting_boards).to include(board)
      end
    end

    context 'user not signed in' do
      it 'fails' do
        request.env["HTTP_REFERER"] = board_path(board)
        patch :uncollect_board, id: user.id, board_id: board.id
        expect(response).to redirect_to(new_user_session_path)
        user.reload
        expect(user.collecting_boards).to include(board)
      end
    end
  end
end