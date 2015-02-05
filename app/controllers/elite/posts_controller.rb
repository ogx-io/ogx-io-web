class Elite::PostsController < ApplicationController
  before_action :set_elite_post, only: [:show, :edit, :update, :destroy]

  # GET /elite/posts
  # GET /elite/posts.json
  def index
    @elite_posts = Elite::Post.all
  end

  # GET /elite/posts/1
  # GET /elite/posts/1.json
  def show
  end

  # GET /elite/posts/new
  def new
    @elite_post = Elite::Post.new
  end

  # GET /elite/posts/1/edit
  def edit
  end

  # POST /elite/posts
  # POST /elite/posts.json
  def create
    @elite_post = Elite::Post.new(elite_post_params)

    respond_to do |format|
      if @elite_post.save
        format.html { redirect_to @elite_post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @elite_post }
      else
        format.html { render :new }
        format.json { render json: @elite_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elite/posts/1
  # PATCH/PUT /elite/posts/1.json
  def update
    respond_to do |format|
      if @elite_post.update(elite_post_params)
        format.html { redirect_to @elite_post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @elite_post }
      else
        format.html { render :edit }
        format.json { render json: @elite_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elite/posts/1
  # DELETE /elite/posts/1.json
  def destroy
    @elite_post.destroy
    respond_to do |format|
      format.html { redirect_to elite_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elite_post
      @elite_post = Elite::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def elite_post_params
      params[:elite_post]
    end
end
