class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle, :resume]
  before_action :set_board, only: [:index, :new, :create, :elites, :deleted]

  # GET /posts
  # GET /posts.json
  def index
    @all_posts = @board.posts.normal
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(10)
  end

  def elites
    @all_posts = @board.posts.normal.elites
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(10)
  end

  def deleted
    authorize @board, :blocked_users?
    @all_posts = @board.posts.deleted
    @posts = @all_posts.desc(:updated_at).page(params[:page]).per(10)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @board = @post.board
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.board = @board
    authorize @post
    if params[:parent]
      @parent = Post.find(params[:parent])
      if !can_reply?(@parent.topic)
        redirect_to :back
      end
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    if not validates_from_touclick
      flash[:error] = "您的验证码可能是不对的。"
      redirect_to :back
      return
    end
    @post = Post.new(post_params)
    @post.board = @board
    authorize @post
    @post.author = current_user
    if @post.parent
      @parent = Post.find(@post.parent)
      if !can_reply?(@parent.topic)
        redirect_to :back
      end
    end

    respond_to do |format|
      if @post.save
        if !@post.parent && params[:lock] == 'true'
          @post.topic.lock = 1
          @post.topic.save
        end
        format.html { redirect_to show_post_topic_path(@post.topic, for_post: @post.id) + '#floor-' + @post.floor.to_s }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    authorize @post
    p = Hash.new
    pp = post_params
    pp.each do |k, v|
      pp[k] = p[k] = 1 - @post.send(k)
    end
    respond_to do |format|
      if @post.update(pp)
        format.json { render json: p, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def resume
    authorize @post
    @post.update(deleted: 0)
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.delete_myself
    respond_to do |format|
      # format.html { redirect_to board_posts_path(@post.board), notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id]) if params[:id]
    @post = Post.find_by_sid(params[:sid]) if params[:sid]
  end

  def set_board
    @board = Board.find(params[:board_id]) if params[:board_id]
    @board = Board.find_by(path: params[:path]) if params[:path]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params[:post].permit(:title, :body, :parent, :topic_id, :elite)
  end

  def can_reply?(topic)
    if topic.lock != 0
      if topic.lock == 2 || topic.user != current_user
        flash[:error] = "所在主题已经被加锁，您不能回复了。"
        return false
      end
    end
    true
  end
end
