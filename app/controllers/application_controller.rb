class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def user_not_authorized(exception)
    if !current_user
      flash[:error] = '您需要先 <a href="/users/sign_in">登录</a> 才能执行此操作！新用户请先 <a href="/users/sign_up">注册</a> 再登录。'
    else
      flash[:error] = '您没有此操作的权限！'
    end

    redirect_to(request.referrer || root_path)
  end

end
