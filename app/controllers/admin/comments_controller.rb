class Admin::CommentsController < ApplicationController

  layout 'admin'

  respond_to :html

  def index
    @all_comments = Comment.all
    @comments = @all_comments.desc(:_id).page(params[:page]).per(100)
    respond_with(@comments)
  end

end
