class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_commentable, only: [:index, :create]

  respond_to :json

  def index
    @comments = @commentable.comments
    respond_with(@comments)
  end

  def show
    respond_with(@comment)
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    respond_with(@comment)
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
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
    params[:comment]
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

end
