class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :delete_all, :resume]

  layout false

  def new
    @comment = Comment.new
    @comment.commentable_type = params[:commentable_type]
    @comment.commentable_id = params[:commentable_id]
    @comment.parent_id = params[:parent_id]
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable_id = @comment.commentable_id.to_i
    if @comment.commentable_type == "Post"
      @comment.board = @comment.commentable.board
    end

    begin
      authorize @comment.commentable, :comment?
      @stage = 1
      @comment.user = current_user

      @comment.user_ip = request.remote_ip
      @comment.user_agent = request.user_agent
      @comment.referer = request.referer

      @stage = 2 if @comment.save
    rescue
      @stage = -1
    end
    respond_to do |format|
      format.js
    end
  end

  def resume
    authorize @comment
    @comment.resume_by(current_user)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize @comment
    @comment.delete_by(current_user)
    respond_to do |format|
      format.js
    end
  end

  def delete_all
    authorize @comment
    @comment.delete_all
    respond_to do |format|
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:common].permit(:body, :parent_id, :commentable_type, :commentable_id)
  end

end
