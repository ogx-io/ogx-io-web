class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :resume]
  before_action :set_board, only: [:index, :edit, :update, :deleted]

  respond_to :html, :xml, :json

  def index
    @all_topics = @board.topics.normal
    @topics = @all_topics.desc(:top, :updated_at, :replied_at).page(params[:page]).per(25)
    respond_with(@topics)
  end

  def deleted
    @all_topics = @board.topics.deleted
    @topics = @all_topics.desc(:top, :updated_at, :replied_at).page(params[:page]).per(25)
    respond_with(@topics)
  end

  def show
    @board = @topic.board
    @first = @topic.posts.first
    per_page = 10
    if params[:page]
      page = params[:page].to_i
    else
      page = 1
    end
    @posts = @topic.posts.normal.where(floor: {'$gte' => (page - 1) * per_page, '$lt' => page * per_page}).collect{|topic| topic}
    @pagination_posts = Kaminari.paginate_array([], total_count: @topic.last_floor + 1).page(page).per(per_page)
    respond_with(@topic)
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

  def resume
    @topic.update(deleted: 0)
    redirect_to :back
  end

  def destroy
    @topic.update(deleted: 1)
    redirect_to :back
  end

  private
  def set_topic
    @topic = Topic.find(params[:id])
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def topic_params
    params[:topic].permit(:top)
  end
end
