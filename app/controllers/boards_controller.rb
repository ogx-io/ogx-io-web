class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy, :blocked_users, :block_user]

  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all
  end

  def manage
    authorize Board.new
    @boards = Board.all.desc(:updated_at).page(params[:page]).per(25)
  end

  def blocked_users
    authorize @board
    @all_users = @board.blocked_users.desc(:created_at)
    @users = @all_users.page(params[:page]).per(25)
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = Board.new
    authorize @board
  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    authorize @board

    respond_to do |format|
      if @board.save
        format.html { redirect_to manage_boards_path(page: params[:page]) }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update
    authorize @board

    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to manage_boards_path(page: params[:page]) }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    authorize @board
    @board.destroy
    respond_to do |format|
      format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def block_user
    username = params[:username].strip
    if User.where(name: username).exists?
      user = User.find_by(name: username)
      blocked_user = BlockedUser.create(user_id: user.id, operator_id: current_user.id)
      @board.blocked_users << blocked_user
    end

    redirect_to :back
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
