# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :posts, :topics, :elites]
  before_action :set_user, only: [:show, :update, :posts, :topics, :elites, :edit_info, :edit_avatar, :edit_accounts, :unbind_account]
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

  def edit_info
    authorize @user
    render layout: 'admin'
  end

  def edit_avatar
    authorize @user
    render layout: 'admin'
  end

  def edit_accounts
    authorize @user
    render layout: 'admin'
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = I18n.t('devise.registrations.updated')
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def unbind_account
    authorize @user
    if params[:type] == 'github'
      @user.update(github_access_token: '', github_user_name: '', github_id: '')
    end
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def set_user
    @user = User.find(params[:id]) if params[:id]
    @user = User.find_by(name: params[:name]) if params[:name]
  end

  def user_params
    params[:user].permit(:nick, :city, :intro, :website, :avatar)
  end
end
