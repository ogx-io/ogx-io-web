require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  let(:another_user) { create(:user) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:board) { create(:board, moderators: [moderator]) }
  let(:post) { create(:post, author: author, board: board) }
  let(:topic) { post.topic }
  let(:topic_list) { 25.times.collect { |i| create(:post, author: author, board: board) } }
  let(:post_list) { 25.times.collect { |i| create(:post, author: author, board: board, topic: topic) } }

  before do
    topic_list
    post_list
    author.reload
  end

  describe '#index' do
    it 'succeeds' do
      get :index, board_id: board.id
      expect(response).to be_success
    end
  end

  describe '#show' do
    it 'succeeds' do
      get :show, id: author.posts.last.topic.id
      expect(response).to be_success
    end

    it '404 if topic not found' do
      expect {
        get :show, id: 0
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe '#show_post' do
    context 'using floor' do
      it 'succeeds' do
        get :show_post, id: topic.id, floor: post_list[18].floor
        expect(response).to redirect_to(topic_path(topic, page: 2) + "#floor-#{post_list[18].floor}")
      end

      it '404 if floor not exists' do
        expect {
          get :show_post, id: topic.id, floor: -1
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'using post id' do
      it 'succeeds' do
        get :show_post, id: topic.id, post_id: post_list[18].id
        expect(response).to redirect_to(topic_path(topic, page: 2) + "#floor-#{post_list[18].floor}")
      end

      it '404 if floor not exists' do
        expect {
          get :show_post, id: topic.id, post_id: '0'
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

  describe '#toggle_lock' do
    context 'locking topic' do
      it 'succeeds if the current user is moderator' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, moderator
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(2)
      end

      it 'succeeds if the current user is author' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, author
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(1)
      end

      it 'fails if the current user is another user' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, another_user
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(0)
      end
    end

    context 'unlocking topic locked by author' do
      before do
        topic.lock = 1
        topic.save
      end

      it 'succeeds if the current user is moderator' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, moderator
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(0)
      end

      it 'succeeds if the current user is author' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, author
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(0)
      end

      it 'fails if the current user is another user' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, another_user
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(1)
      end
    end

    context 'unlocking topic locked by moderator' do
      before do
        topic.lock = 2
        topic.save
      end

      it 'succeeds if the current user is moderator' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, moderator
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(0)
      end

      it 'succeeds if the current user is author' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, author
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(2)
      end

      it 'fails if the current user is another user' do
        request.env["HTTP_REFERER"] = topic_path(topic)
        sign_in :user, another_user
        patch :toggle_lock, id: topic.id
        expect(response).to redirect_to(topic_path(topic))
        topic.reload
        expect(topic.lock).to eq(2)
      end
    end
  end

  describe '#destroy' do
    it 'succeeds if the current user is moderator' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, moderator
      delete :destroy, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(2)
    end

    it 'fails if the current user is author' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, author
      delete :destroy, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(0)
    end

    it 'fails if the current user is another user' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, another_user
      delete :destroy, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(0)
    end
  end

  describe '#resume' do
    before do
      topic.delete_by(moderator)
    end

    it 'succeeds if the current user is moderator' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, moderator
      delete :resume, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(0)
    end

    it 'fails if the current user is author' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, author
      delete :resume, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(2)
    end

    it 'fails if the current user is another user' do
      request.env["HTTP_REFERER"] = topic_path(topic)
      sign_in :user, another_user
      delete :resume, id: topic.id
      expect(response).to redirect_to(topic_path(topic))
      topic.reload
      expect(topic.deleted).to eq(2)
    end
  end
end