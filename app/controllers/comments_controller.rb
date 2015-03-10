class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :resume]

  layout false

  def create
    @comment = Comment.new(comment_params)

    authorize @comment.commentable, :comment?

    if @comment.commentable_type == "Post"
      @comment.board = @comment.commentable.board
    end

    @comment.user = current_user
    @comment.user_ip = request.remote_ip
    @comment.user_agent = request.user_agent
    @comment.referer = request.referer

    @comment.save

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

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:comment].permit(:body, :commentable_type, :commentable_id)
  end

end
