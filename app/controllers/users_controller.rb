class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :posts, :topics, :elites]
  before_action :set_user, only: [:show, :posts, :topics, :elites, :deleted_posts]
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    authorize @user
    @all_topics = @user.topics.normal
    @topics = @all_topics.desc(:created_at).page(params[:page]).per(15)
    render 'topics'
  end

  def posts
    authorize @user
    @all_posts = @user.posts.normal
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(15)
    render 'posts', locals: { index: 1 }
  end

  def topics
    authorize @user
    @all_topics = @user.topics.normal
    @topics = @all_topics.desc(:created_at).page(params[:page]).per(15)
  end

  def elites
    authorize @user
    @all_posts = @user.posts.normal.elites
    @posts = @all_posts.desc(:created_at).page(params[:page]).per(15)
    render 'posts', locals: { index: 3 }
  end

  def deleted_posts
    authorize @user
    @all_posts = @user.posts.deleted
    @posts = @all_posts.desc(:updated_at).page(params[:page]).per(15)
    @refresh = true
    render 'posts', locals: { index: 4 }
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end

  def set_user
    @user = User.find(params[:id]) if params[:id]
    @user = User.find_by(name: params[:name]) if params[:name]
  end

end
