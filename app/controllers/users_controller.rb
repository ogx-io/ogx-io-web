# coding: utf-8
class UsersController < ApplicationController
  include NodeShowing

  before_filter :authenticate_user!, except: [:show, :posts, :topics, :elites]
  before_action :set_user, only: [:show, :update, :posts, :topics, :elites, :edit_info, :edit_avatar, :edit_accounts, :unbind_account, :edit_self_intro, :edit_blog, :create_blog, :update_self_intro, :show_blog]
  after_action :verify_authorized

  def show
    authorize @user
  end

  def show_blog
    authorize @user
    @board = @user.blog
    show_node(@board)
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

  def edit_blog
    authorize @user
    @blog = @user.blog
    render layout: 'admin'
  end

  def create_blog
    @blog = Board.new(name: I18n.t('users.default_blog_name', user_name: @user.nick), path: @user.id.to_s, parent: Node.blog, moderator_ids: [@user.id], creator_id: @user.id)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to :back, notice: 'Blog was successfully created.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def edit_accounts
    authorize @user
    render layout: 'admin'
  end

  def edit_self_intro
    authorize @user
    render layout: 'admin'
  end

  def update_self_intro
    authorize @user
    @user.create_user_detail unless @user.user_detail
    respond_to do |format|
      if @user.user_detail.update(intro: params[:intro])
        flash[:notice] = I18n.t('devise.registrations.updated')
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back }
      end
    end
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
    params[:user].permit(:nick, :city, :intro, :website, :avatar, :enable_email_notification)
  end
end
