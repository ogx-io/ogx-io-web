class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :show_post, :edit, :update, :destroy, :resume, :toggle_lock]
  before_action :set_board, only: [:index, :edit, :update, :deleted]

  respond_to :html, :xml, :json

  def index
    @all_topics = @board.topics.normal
    @topics = @all_topics.desc(:top, :replied_at).page(params[:page]).per(15)
    respond_with(@topics)
  end

  def show
    @board = @topic.board
    @first = @topic.posts.first

    @topic.inc_click_count if params[:page].blank?

    @all_posts = @topic.posts.normal
    @posts = @all_posts.asc(:floor).page(params[:page]).per(10)
    respond_with(@topic)
  end

  def show_post
    if params[:floor]
      post = @topic.posts.find_by(floor: params[:floor].to_i)
    else
      post = Post.find(params[:post_id])
    end
    page = @topic.posts.normal.where(floor: {'$lt' => post.floor}).count / 10 + 1
    redirect_to topic_path(post.topic, page: page) + "#floor-#{post.floor}"
  end

  def toggle_lock
    authorize @topic
    if @topic.lock.to_i == 0
      @topic.lock_by(current_user)
    else
      @topic.unlock_by(current_user)
    end
    @topic.save
    redirect_to :back
  end

  def resume
    authorize @topic
    @topic.resume_by(current_user)
    redirect_to :back
  end

  def destroy
    authorize @topic
    @topic.delete_by(current_user)
    redirect_to :back
  end

  private
  def set_topic
    @topic = Topic.find(params[:id]) if params[:id]
    @topic = Topic.find_by_sid(params[:sid]) if params[:sid]
  end

  def set_board
    @board = Board.find(params[:board_id]) if params[:board_id]
    @board = Board.find_by(path: params[:path]) if params[:path]
  end

end
