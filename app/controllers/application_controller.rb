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
    flash[:error] = exception.policy.err_msg || '您没有此操作的权限！'

    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path) }
      format.js { render js: "alert('#{flash[:error]}');" }
    end

  end

end
