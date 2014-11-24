class BlockedUsersController < ApplicationController
  before_action :set_blocked_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @blocked_users = BlockedUser.all
    respond_with(@blocked_users)
  end

  def show
    respond_with(@blocked_user)
  end

  def new
    @blocked_user = BlockedUser.new
    respond_with(@blocked_user)
  end

  def edit
  end

  def create
    @blocked_user = BlockedUser.new(blocked_user_params)
    @blocked_user.save
    respond_with(@blocked_user)
  end

  def update
    @blocked_user.update(blocked_user_params)
    respond_with(@blocked_user)
  end

  def destroy
    @blocked_user.destroy
    redirect_to :back
  end

  private
    def set_blocked_user
      @blocked_user = BlockedUser.find(params[:id])
    end

    def blocked_user_params
      params[:blocked_user]
    end
end
