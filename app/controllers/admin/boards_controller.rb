class Admin::BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  # GET /admin/boards
  # GET /admin/boards.json
  def index
    authorize Board.new, :manage?
    @all_boards = Board.all
    @boards = @all_boards.desc(:updated_at).page(params[:page]).per(25)
  end

  # GET /admin/boards/1
  # GET /admin/boards/1.json
  def show
  end

  # GET /admin/boards/new
  def new
    @board = Board.new
  end

  # GET /admin/boards/1/edit
  def edit
  end

  # POST /admin/boards
  # POST /admin/boards.json
  def create
    @board = Board.new(board_params)
    authorize @board

    respond_to do |format|
      if @board.save
        format.html { redirect_to admin_boards_url }
        format.json { render :show, status: :created, location: @admin_board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/boards/1
  # PATCH/PUT /admin/boards/1.json
  def update
    authorize @board

    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to admin_boards_url }
        format.json { render :show, status: :ok, location: @admin_board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/boards/1
  # DELETE /admin/boards/1.json
  def destroy
    @board.destroy
    respond_to do |format|
      format.html { redirect_to admin_boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_params
      p = params[:board].permit(:name, :path, :intro, :moderator_ids, :status)
      p[:moderator_ids] = p[:moderator_ids].split.collect{|user_name| User.find_by(name: user_name).id} if p[:moderator_ids]
      p
    end
end
