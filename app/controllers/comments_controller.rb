class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

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
    @comment.user = current_user
    @comment.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_with(@comment)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:comment].permit(:body, :parent_id, :commentable_type, :commentable_id)
  end

end
