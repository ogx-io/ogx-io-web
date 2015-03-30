class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :record_last_visit_info

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def user_not_authorized(exception)
    message = (exception.policy.respond_to?('err_msg') && !exception.policy.err_msg.blank?) ? exception.policy.err_msg : t('policies.common.no_permission')

    respond_to do |format|
      format.html { flash[:error] = message; redirect_to(request.referrer || root_path) }
      format.js do
        flash.now[:error] = message
        unsanitized_message = flash[:error]
        sanitized_message = ActionController::Base.helpers.strip_tags(unsanitized_message)
        render js: "alert('#{sanitized_message}');"
      end
    end
  end

  def record_last_visit_info
    if current_user
      current_user.update(last_visit_ip: request.remote_ip, last_visited_at: Time.now)
    end
  end

end
