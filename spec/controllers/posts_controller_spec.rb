require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:another_user) { create(:user) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:board) { create(:board) }
  let(:old_post) { create(:post, author: author, board: board) }
  let(:new_post) { build(:post, author: author, board: board) }
  let(:topic) { old_post.topic }
  let(:topic_list) { 25.times.collect { |i| create(:post, author: author, board: board) } }
  let(:post_list) { 25.times.collect { |i| create(:post, author: author, board: board, topic: topic) } }
  let(:comment_list) { 25.times.collect { |i| create(:comment, commentable: old_post, user: another_user) } }

  before do
    board.moderators << moderator
    topic_list
    post_list
    comment_list
    author.reload
  end

  describe '#index' do
    it 'succeeds' do
      get :index, board_id: board.id
      expect(response).to be_success
    end
  end

  describe '#show' do
    context 'when the post is normal' do
      it 'succeeds' do
        get :show, id: old_post.id
        expect(response).to be_success
      end
    end

    context 'when the post is deleted' do
      before do
        old_post.delete_by(moderator)
      end

      it 'fails if the current user is another user' do
        sign_in :user, another_user
        get :show, id: old_post.id
        expect(request.flash[:error]).not_to be_blank
        expect(response).not_to be_success
      end

      it 'succeeds if the current user is author' do
        sign_in :user, author
        get :show, id: old_post.id
        expect(response).to be_success
      end

      it 'succeeds if the current user is moderator' do
        sign_in :user, moderator
        get :show, id: old_post.id
        expect(response).to be_success
      end
    end
  end

  describe '#comments' do
    it 'succeeds' do
      xhr :get, :comments, id: old_post.id
      expect(response).to be_success
    end
  end

  describe '#new' do
    context 'user signed in' do
      it 'succeeds if the current user is a normal user' do
        sign_in :user, another_user
        get :new, board_id: board.id
        expect(response).to be_success
      end

      it 'fails if the current user is blocked in the board' do
        create(:blocked_user, user: another_user, blockable: board, blocker: moderator)
        sign_in :user, another_user
        get :new, board_id: board.id
        expect(response).not_to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'user not signed in' do
      it 'fails' do
        get :new, board_id: board.id
        expect(response).not_to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#edit' do
    context 'user signed in' do
      it 'succeeds if the current user is author' do
        sign_in :user, author
        get :edit, id: old_post.id, board_id: board.id
        expect(response).to be_success
      end

      it 'fails if the author is blocked in the board' do
        create(:blocked_user, user: author, blockable: board, blocker: moderator)
        sign_in :user, author
        get :edit, id: old_post.id, board_id: board.id
        expect(response).not_to be_success
        expect(request.flash[:error]).not_to be_blank
      end

      it 'fails if the current user is not the author' do
        sign_in :user, moderator
        get :edit, id: old_post.id, board_id: board.id
        expect(response).not_to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end

    context 'user not signed in' do
      it 'fails' do
        get :edit, id: old_post.id, board_id: board.id
        expect(response).not_to be_success
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#create' do
    before do
      @new_post_info = {
          title: new_post.title,
          body: new_post.body
      }
    end

    context 'user signed in' do
      before do
        sign_in :user, another_user
      end

      it 'succeeds creating a new topic if the current user is a normal user' do
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count + 1)
        expect(board.topics.count).to eq(old_topic_count + 1)
        new_one = another_user.posts.last
        expect(response).to redirect_to(show_topic_post_path(new_one.topic.id, new_one.id))
      end

      it 'fails creating a new topic if the current user is a user blocked by moderator' do
        create(:blocked_user, user: another_user, blocker: moderator, blockable: board)
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count)
        expect(board.topics.count).to eq(old_topic_count)

        expect(request.flash[:error]).not_to be_blank
        expect(response).to render_template(:new)
      end

      it 'fails creating a new topic if the current user is a user blocked by admin' do
        another_user.status = 1
        another_user.save
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count)
        expect(board.topics.count).to eq(old_topic_count)

        expect(request.flash[:error]).not_to be_blank
        expect(response).to render_template(:new)
      end

      it 'succeeds creating a new reply if the current user is a normal user' do
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        old_topic_post_count = topic.posts.count
        @new_post_info['parent_id'] = old_post.id
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count + 1)
        expect(board.topics.count).to eq(old_topic_count)
        expect(topic.posts.count).to eq(old_topic_post_count + 1)
        new_one = another_user.posts.last
        expect(response).to redirect_to(show_topic_post_path(new_one.topic.id, new_one.id))
      end

      it 'fails creating a new reply if the current user is a user blocked by moderator' do
        create(:blocked_user, user: another_user, blocker: moderator, blockable: board)
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        old_topic_post_count = topic.posts.count
        @new_post_info['parent_id'] = old_post.id
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count)
        expect(board.topics.count).to eq(old_topic_count)
        expect(topic.posts.count).to eq(old_topic_post_count)

        expect(request.flash[:error]).not_to be_blank
        expect(response).to render_template(:new)
      end

      it 'fails creating a new reply if the current user is a user blocked by admin' do
        another_user.status = 1
        another_user.save
        old_post_count = another_user.posts.count
        old_topic_count = board.topics.count
        old_topic_post_count = topic.posts.count
        @new_post_info['parent_id'] = old_post.id
        post :create, board_id: board.id, post: @new_post_info
        another_user.reload
        expect(another_user.posts.count).to eq(old_post_count)
        expect(board.topics.count).to eq(old_topic_count)
        expect(topic.posts.count).to eq(old_topic_post_count)

        expect(request.flash[:error]).not_to be_blank
        expect(response).to render_template(:new)
      end

      it 'back to the form with error message when the validation fails' do
        @new_post_info['title'] = 'too long title' * 100
        post :create, board_id: board.id, post: @new_post_info
        expect(response).to render_template(:new)
        expect(assigns(:post).errors[:title]).not_to be_blank
      end

      it 'can not create new post too fast' do
        create(:post, author: another_user, board: board)
        post :create, board_id: board.id, post: @new_post_info
        expect(request.flash[:error]).not_to be_blank
        expect(response).to render_template(:new)
      end

      it 'can preview post by using ajax request' do
        xhr :post, :create, board_id: board.id, preview: 'true', post: @new_post_info
        expect(response).to render_template('posts/_preview')
      end

      it 'can not preview post when the validation fails' do
        @new_post_info['title'] = 'too long title' * 100
        xhr :post, :create, board_id: board.id, preview: 'true', post: @new_post_info
        expect(response).not_to render_template('posts/_preview')
      end
    end

    context 'user not signed in' do
      it 'fails' do
        post :create, board_id: board.id, post: @new_post_info
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#update' do
    before do
      @new_post_info = {
          title: 'new title',
          body: 'new body'
      }
    end

    context 'user signed in' do
      before do
        sign_in :user, author
      end

      it 'succeeds if the current user is author' do
        post :update, id: old_post.id, post: @new_post_info
        expect(response).to redirect_to(post_path(old_post))
        old_post.reload
        expect(old_post.title).to eq('new title')
      end

      it 'fails if the current user is blocked by moderator' do
        create(:blocked_user, user: author, blocker: moderator, blockable: board)
        post :update, id: old_post.id, post: @new_post_info
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.title).not_to eq('new title')
      end

      it 'fails if the current user is blocked by admin' do
        author.status = 1
        author.save
        post :update, id: old_post.id, post: @new_post_info
        expect(request.flash[:error]).not_to be_blank
        old_post.reload
        expect(old_post.title).not_to eq('new title')
      end

      it 'back to the form with error message when the validation fails' do
        @new_post_info['title'] = 'too long title' * 100
        post :update, id: old_post.id, post: @new_post_info
        expect(response).to render_template(:edit)
        expect(assigns(:post).errors[:title]).not_to be_blank
      end

      it 'can preview post by using ajax request' do
        xhr :post, :update, id: old_post.id, preview: 'true', post: @new_post_info
        expect(response).to render_template('posts/_preview')
      end

      it 'can not preview post when the validation fails' do
        @new_post_info['title'] = 'too long title' * 100
        xhr :put, :update, id: old_post.id, preview: 'true', post: @new_post_info
        expect(response).not_to render_template('posts/_preview')
      end
    end

    context 'user not signed in' do
      it 'fails' do
        post :update, id: old_post.id, post: @new_post_info
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#set_elite' do
    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      xhr :patch, :set_elite, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_truthy
    end

    it 'fails if the current user is author' do
      sign_in :user, author
      xhr :patch, :set_elite, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_falsey
    end

    it 'fails if the current user is another user' do
      sign_in :user, another_user
      xhr :patch, :set_elite, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_falsey
    end
  end

  describe '#unset_elite' do
    before do
      Elite::Post.add_post(old_post, moderator)
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      xhr :patch, :unset_elite, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_falsey
    end

    it 'succeeds when the current user is author' do
      sign_in :user, author
      xhr :patch, :unset_elite, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_falsey
    end

    it 'fails if the current user is another user' do
      sign_in :user, another_user
      xhr :patch, :unset_elite, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.is_elite?).to be_truthy
    end
  end

  describe '#top_up' do
    it 'succeeds when the current user is moderator' do
      old_top_value = old_post.top
      sign_in :user, moderator
      xhr :patch, :top_up, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.top).to eq(old_top_value + 1)
    end

    it 'fails if the current user is another user' do
      old_top_value = old_post.top
      sign_in :user, another_user
      xhr :patch, :top_up, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.top).to eq(old_top_value)
    end
  end

  describe '#top_clear' do
    before do
      old_post.top = 2
      old_post.save
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      xhr :patch, :top_clear, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.top).to eq(0)
    end

    it 'fails if the current user is another user' do
      old_top_value = old_post.top
      sign_in :user, another_user
      xhr :patch, :top_clear, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.top).to eq(old_top_value)
    end
  end

  describe '#destroy' do
    it 'succeeds when the current user is admin' do
      sign_in :user, admin
      xhr :delete, :destroy, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(2)
    end

    it 'succeeds when the current user is moderator' do
      sign_in :user, moderator
      xhr :delete, :destroy, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(2)
    end

    it 'succeeds when the current user is author' do
      sign_in :user, author
      xhr :delete, :destroy, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(1)
    end

    it 'succeeds when the current user is author even who is blocked by moderator' do
      sign_in :user, author
      create(:blocked_user, user: author, blocker: moderator, blockable: board)
      xhr :delete, :destroy, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(1)
    end

    it 'succeeds when the current user is author even who is blocked by admin' do
      sign_in :user, author
      author.status = 1
      author.save
      xhr :delete, :destroy, id: old_post.id
      expect(response).to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(1)
    end

    it 'fails when the current user is another user' do
      sign_in :user, another_user
      xhr :delete, :destroy, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(0)
    end

    it 'fails when the post is already deleted' do
      old_post.delete_by(moderator)
      sign_in :user, author
      xhr :delete, :destroy, id: old_post.id
      expect(response).not_to render_template(:refresh)
      old_post.reload
      expect(old_post.deleted).to eq(2)
    end
  end

  describe '#resume' do
    context 'post deleted by moderator' do
      before do
        old_post.delete_by(moderator)
      end

      it 'succeeds when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: old_post.id
        expect(response).to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(0)
      end

      it 'fails when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(2)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(2)
      end
    end

    context 'post deleted by author' do
      before do
        old_post.delete_by(author)
      end

      it 'fails when the current user is moderator' do
        sign_in :user, moderator
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end

      it 'succeeds when the current user is author' do
        sign_in :user, author
        xhr :patch, :resume, id: old_post.id
        expect(response).to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(0)
      end

      it 'fails when the current user is author but who is blocked by admin' do
        sign_in :user, author
        author.update(status: 1)
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end

      it 'fails when the current user is author but who is blocked by moderator' do
        sign_in :user, author
        create(:blocked_user, user: author, blocker: moderator, blockable: board)
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end

      it 'fails when the current user is another user' do
        sign_in :user, another_user
        xhr :patch, :resume, id: old_post.id
        expect(response).not_to render_template(:refresh)
        old_post.reload
        expect(old_post.deleted).to eq(1)
      end
    end
  end
end