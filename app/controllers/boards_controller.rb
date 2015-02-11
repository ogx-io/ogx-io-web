class BoardsController < ApplicationController
  before_action :set_board, only: [:show]

  # GET /boards/1
  # GET /boards/1.json
  def show
    @all_topics = @board.topics.normal
    @topics = @all_topics.desc(:replied_at).page(params[:page]).per(15)
    @top_posts = @board.posts.top.desc(:top)
    render 'topics/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id]) if params[:id]
      @board = Board.find_by(path: params[:path]) if params[:path]
    end

end
