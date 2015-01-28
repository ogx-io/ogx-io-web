class BoardsController < ApplicationController
  before_action :set_board, only: [:show]

  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all.asc(:name)
  end


  # GET /boards/1
  # GET /boards/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id]) if params[:id]
      @board = Board.find_by(path: params[:path]) if params[:path]
    end

end
