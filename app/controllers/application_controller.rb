class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def validates_from_touclick
    check_address = params['check_address']
    check_key = params['check_key']
    check_address_array = check_address.split(',')

    host = check_address_array[0].split('.')[0]
    return false if (/^[a-z0-9]+$/.match(host)).nil?

    path = check_address_array[1].split('.')[0]
    return false if (/^[a-z0-9]+$/.match(path)).nil?

    str_url = "http://#{host}.touclick.com/#{path}.touclick?i=#{check_key}&p=#{request.remote_ip}&un=0&ud=0&b=#{Rails.application.secrets.touclick_pub_key}&z=#{Rails.application.secrets.touclick_secret_key}"

    require 'net/http'
    url = URI.parse(str_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    res.body == '<<[yes]>>'
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
