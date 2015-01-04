class Admin::BlockedUsersController < ApplicationController

  layout 'admin'

  before_action :set_blocked_user, only: [:destroy]

  respond_to :html

  def index
    @all_blocked_users = BlockedUser.all
    @blocked_users = @all_blocked_users.desc(:_id).page(params[:page]).per(50)
    respond_with(@blocked_users)
  end

  def create
    @blocked_user = BlockedUser.new(blocked_user_params)
    if !BlockedUser.check_if_blocked(@blocked_user.blockable, @blocked_user.user)
      @blocked_user.block_by(current_user)
    end
    respond_with(@blocked_user)
  end

  def destroy
    @blocked_user.delete_by(current_user)
    respond_with(@blocked_user)
  end

  private

  def set_blocked_user
    @blocked_user = BlockedUser.find(params[:id])
  end

  def blocked_user_params
    params[:blocked_user].permit(:blockable_type, :blockable_id)
  end
end
