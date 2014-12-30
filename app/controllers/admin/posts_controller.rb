class Admin::PostsController < ApplicationController

  layout 'admin'

  before_action :set_post, only: [:destroy, :resume]

  respond_to :html

  def index
    authorize current_user, :manage?
    @all_posts = Post.all
    @posts = @all_posts.desc(:_id).page(params[:page]).per(20)
    respond_with(@admin_posts)
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
