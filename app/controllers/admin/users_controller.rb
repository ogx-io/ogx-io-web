class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:update]

  layout 'admin'

  # GET /admin/users
  # GET /admin/users.json
  def index
    authorize User
    @all_users = User.all
    @users = @all_users.desc(:_id).page(params[:page]).per(20)
  end


  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    authorize @user
    @user.update(user_params)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user].permit(:status)
    end
end
