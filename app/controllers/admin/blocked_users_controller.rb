class Admin::BlockedUsersController < ApplicationController

  layout 'admin'

  before_action :set_blocked_user, only: [:destroy]

  respond_to :html

  def index
    @all_blocked_users = BlockedUser.where(blockable_type: "Board")

    if !current_user.admin?
      @all_blocked_users = @all_blocked_users.in(blockable_id: current_user.managing_board_ids)
    end

    if params[:board_id]
      @board = Board.find(params[:board_id].to_i)
      if @board
        @blocked_user = BlockedUser.new
        @blocked_user.blockable = @board
        @all_blocked_users = @all_blocked_users.where(blockable_id: @board.id)
      end
    end

    @blocked_users = @all_blocked_users.desc(:_id).page(params[:page]).per(50)
    respond_with(@blocked_users)
  end

  def create
    @blocked_user = BlockedUser.new(blocked_user_params)
    @blocked_user[:blockable_id] = @blocked_user[:blockable_id].to_i
    if params[:username]
      user = User.find_by(name: params[:username])
      if user
        @blocked_user.user = user
      else
        redirect_to :back
        return
      end
    end
    @blocked_user.blocker = current_user
    @blocked_user.save
    redirect_to :back
  end

  def destroy
    @blocked_user.destroy
    respond_to do |format|
      format.js { render js: "$('#blocked-user-#{@blocked_user.id}').remove()" }
    end
  end

  private

  def set_blocked_user
    @blocked_user = BlockedUser.find(params[:id])
  end

  def blocked_user_params
    params[:blocked_user].permit(:blockable_type, :blockable_id, :user_id)
  end
end
