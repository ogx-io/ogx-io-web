class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :posts, :topics, :elites]
  before_action :set_user, only: [:show, :update, :posts, :topics, :elites, :deleted_posts]
  after_action :verify_authorized

  def show
    authorize @user
  end

  def posts
    authorize @user
    if @user == current_user
      @all_posts = @user.posts
    else
      @all_posts = @user.posts.normal
    end
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(20)
    render 'posts'
  end

  def topics
    authorize @user
    @all_topics = @user.topics.normal
    @topics = @all_topics.desc(:created_at).page(params[:page]).per(15)
  end

  def elites
    authorize @user
    if @user == current_user
      @all_posts = @user.elite_posts
    else
      @all_posts = @user.elite_posts.normal
    end
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(20)
    render 'elites'
  end

  private

  def set_user
    @user = User.find(params[:id]) if params[:id]
    @user = User.find_by(name: params[:name]) if params[:name]
  end

end
