class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :set_elite, :unset_elite, :top_up, :top_clear, :resume, :comments]
  before_action :set_board, only: [:index, :new, :create]

  # GET /posts
  # GET /posts.json
  def index
    @all_posts = @board.posts.normal
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(20)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize @post

    @board = @post.board
    @comment = Comment.new
    @comment.commentable = @post
  end

  def comments
    @comment = Comment.new
    @comment.commentable = @post
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.board = @board
    @post.parent_id = params[:parent_id]

    authorize @post
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.board = @board

    if params[:preview] != "true"
      begin
        authorize @post
      rescue Pundit::NotAuthorizedError => exception
        message = exception.policy.err_msg || '您没有此操作的权限！'
        respond_to do |format|
          format.html { flash.now[:error] = message; render :new }
        end
        return
      end
    end

    @post.topic = @post.parent.topic if @post.parent
    @post.author = current_user
    @post.user_ip = request.remote_ip
    @post.user_agent = request.user_agent
    @post.referer = request.referer

    respond_to do |format|
      if params[:preview] == "true"
        if @post.valid?
          @post.convert_body
          format.html { render partial: 'preview', locals: { type: 'new' } }
        else
          format.html { render html: "<script type=\"text/javascript\">$('.post-form').submit()</script>".html_safe }
        end
      else
        if @post.save
          if @post.parent.nil? && params[:lock] == 'true'
            @post.topic.lock = 1
            @post.topic.save
          end
          format.html { redirect_to show_topic_post_path(@post.topic.id, @post.id) }
        else
          format.html { render :new }
        end
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post if params[:preview] != "true"
    respond_to do |format|
      if params[:preview] == "true"
        @board = @post.board
        @post = Post.new(post_params)
        @post.board = @board
        if @post.valid?
          @post.author = current_user
          @post.convert_body
          format.html { render partial: 'preview', locals: { type: 'edit' } }
        else
          format.html { render html: "<script type=\"text/javascript\">$('.post-form').submit()</script>".html_safe }
        end
      else
        if @post.update(post_params)
          format.html { redirect_to @post }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def set_elite
    authorize @post
    Elite::Post.add_post(@post, current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def unset_elite
    authorize @post
    @post.elite_post.delete_by(current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def top_up
    authorize @post
    @post.top += 1
    @post.save
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def top_clear
    authorize @post
    @post.top = 0
    @post.save
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def resume
    authorize @post
    @post.resume_by(current_user)
    respond_to do |format|
      format.js do
        render 'refresh'
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.delete_by(current_user)
    respond_to do |format|
      format.js do
        render 'refresh'
      end
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
    params[:post].permit(:title, :body, :parent_id)
  end

end
