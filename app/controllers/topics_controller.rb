class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :show_post, :edit, :update, :destroy, :resume, :toggle_lock]
  before_action :set_board, only: [:index, :edit, :update, :deleted]

  respond_to :html, :xml, :json

  def index
    @all_topics = @board.topics.normal
    @topics = @all_topics.desc(:top, :updated_at, :replied_at).page(params[:page]).per(10)
    respond_with(@topics)
  end

  def show
    @board = @topic.board
    @first = @topic.posts.first

    @all_posts = @topic.posts.normal
    @posts = @all_posts.asc(:_id).page(params[:page]).per(10)
    respond_with(@topic)
  end

  def show_post
    post = Post.find(params[:for_post])
    if post
      page = @topic.posts.normal.where(_id: {'$lt' => post.id}).count / 10 + 1
      redirect_to topic_path(post.topic, page: page) + "#floor-#{post.floor}"
    else
      redirect_to :back
    end
  end

  def new
    @topic = Topic.new
    respond_with(@topic)
  end

  def edit
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.save
    respond_with(@topic)
  end

  def update
    authorize @topic
    p = topic_params
    @topic.update(p)
    @topic.update(updated_at: @topic.replied_at) if p['top'] == '0'
    redirect_to :back
    # respond_with(@topic)
  end

  def toggle_lock
    authorize @topic
    if @topic.lock.to_i == 0
      @topic.lock = 2 if @topic.board.is_moderator?(current_user)
      @topic.lock = 1 if current_user == @topic.user
    else
      @topic.lock = 0
    end
    @topic.save
    redirect_to :back
  end

  def resume
    authorize @topic
    @topic.update(deleted: 0)
    redirect_to :back
  end

  def destroy
    authorize @topic
    @topic.update(deleted: 1)
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

  def topic_params
    params[:topic].permit(:top)
  end
end
