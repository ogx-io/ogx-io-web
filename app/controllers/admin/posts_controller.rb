class Admin::PostsController < ApplicationController

  layout 'admin'

  before_action :set_post, only: [:destroy, :resume]

  respond_to :html

  def index
    authorize current_user, :manage?
    @all_posts = Post.all

    if !current_user.admin?
      @all_posts = @all_posts.in(board_id: current_user.managing_board_ids)
    end

    if !params[:board_id].blank?
      @all_posts = @all_posts.where(board_id: params[:board_id].to_i)
    end

    if !params[:status].blank?
      case params[:status].to_i
        when 1
          @all_posts = @all_posts.normal
        when 2
          @all_posts = @all_posts.deleted
      end
    end

    @posts = @all_posts.desc(:_id).page(params[:page]).per(20)
    respond_with(@posts)
  end

  def resume
    authorize @post
    @post.resume_by(current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def destroy
    authorize @post
    @post.delete_by(current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

end
