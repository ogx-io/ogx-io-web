class NotificationsController < ApplicationController
  before_action :set_user, only: [:index, :clean]
  before_action :set_notification, only: [:destroy]

  def index
    authorize Notification::Base
    @all_notifications = @user.notifications
    @notifications = @all_notifications.desc(:_id).page(params[:page]).per(20)
  end

  def destroy
    authorize @notification
    @notification.destroy
    redirect_to :back
  end

  def clean
    authorize Notification::Base
    @user.notifications.delete_all
    redirect_to :back
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_notification
    @notification = Notification::Base.find(params[:id])
  end
end
