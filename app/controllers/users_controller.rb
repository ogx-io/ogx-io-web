# coding: utf-8
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :posts, :topics, :elites, :auth_with_github, :github_callback]
  before_action :set_user, only: [:show, :update, :posts, :topics, :elites, :deleted_posts]
  after_action :verify_authorized, except: [:auth_with_github, :github_callback]

  include GithubHelper

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

  def auth_with_github
    redirect_to github_redirect_uri
  end

  def github_callback
    code = params[:code]
    token = github_user_token(code)
    token_owner = User.where(github_access_token: token).first
    if token
      if token_owner
        # Registered user
        # Log him in
        sign_in(:user, token_owner)
        redirect_to root_path
      elsif current_user
        # Registered user is binding
        # Binding for this user
        current_user.github_access_token = token
        github_acc_info = user_info_for_token(token)
        ogx_acc_info = github_acc_info_to_ogx_acc_info(github_acc_info)
        update_user_with_translated_info_from_github(current_user, ogx_acc_info)
        flash[:notice] = t('users.github_binding_success')
        redirect_to edit_user_registration_path
      else
        github_acc_info = user_info_for_token(token)
        github_acc_email = github_acc_info[:email]
        github_acc_id = github_acc_info[:id]

        if !github_acc_id.blank?
          id_guessed_user = User.where(github_id: github_acc_id).first
        end
        if !github_acc_email.blank?
          email_guessed_user = User.where(email: github_acc_email).first
        end
        if id_guessed_user
          # Update his github access token
          id_guessed_user.github_access_token = token
          ogx_acc_info = github_acc_info_to_ogx_acc_info(github_acc_info)
          update_user_with_translated_info_from_github(id_guessed_user, ogx_acc_info)
          sign_in(:user, id_guessed_user)
          flash[:notice] = t('users.github_sign_in_success')
          redirect_to "https://ogx.io"
        elsif email_guessed_user
          # Found the user by email
          email_guessed_user.github_access_token = token
          ogx_acc_info = github_acc_info_to_ogx_acc_info(github_acc_info)
          update_user_with_translated_info_from_github(email_guessed_user, ogx_acc_info)
          sign_in(:user, email_guessed_user)
          flash[:notice] = t('users.github_sign_in_success')
          redirect_to "https://ogx.io"
        else
          # Register a new user
          set_session_github_token(token)
          redirect_to new_user_registration_path
        end
      end
    else
      flash[:error] = t('users.github_binding_error')
      redirect_to "https://ogx.io"
    end
  end

  private

  def set_user
    @user = User.find(params[:id]) if params[:id]
    @user = User.find_by(name: params[:name]) if params[:name]
  end

end
