class Admin::BoardsController < ApplicationController
  before_action :set_board, only: [:edit, :update, :destroy]

  layout 'admin'

  # GET /admin/boards/new
  def new
    @board = Board.new
    if params[:parent_id]
      @board.parent_id = params[:parent_id]
    end
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
        format.html { redirect_to admin_nodes_path(parent_id: @board.parent_id) }
      else
        format.html { render :new }
        format.js { render js: 'alert("error")' }
      end
    end
  end

  # PATCH/PUT /admin/boards/1
  # PATCH/PUT /admin/boards/1.json
  def update
    authorize @board

    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to admin_nodes_path(parent_id: @board.parent_id) }
        format.js { render 'admin/nodes/refresh', locals: { node: @board } }
      else
        format.html { render :edit }
        format.js { render js: 'alert("error")' }
      end
    end
  end

  # DELETE /admin/boards/1
  # DELETE /admin/boards/1.json
  def destroy
    @board.status = :deleted
    @board.save
    respond_to do |format|
      format.js { render 'admin/nodes/refresh', locals: { node: @board } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_params
      p = params[:board].permit(:name, :path, :parent_id, :intro, :moderator_ids, :status)
      p[:moderator_ids] = p[:moderator_ids].split.collect{|user_name| User.find_by(name: user_name).id} if p[:moderator_ids]
      p
    end
end
