module ApplicationHelper

  class ::NilClass
    def method_missing(name)
      nil
    end
  end

  def user_link(user)
    if user
      link_to(user.nick ? user.nick : user.name, show_user_path(user.name), class: 'user-link', title: "@#{user.name}").html_safe
    else
      '<span class="user-link">已注销</span>'.html_safe
    end
  end

  def full_user_link(user)
    if user
      (link_to(user.nick ? user.nick : user.name, show_user_path(user.name)) + " @#{user.name}").html_safe
    else
      '已注销'.html_safe
    end
  end

  def avatar(user, size = 70)
    if user
      url = user.get_avatar(size)
    else
      url = "http://www.gravatar.com/avatar/?s=#{size}"
    end
    image_tag(url, class: 'avatar', width: size, height: size)
  end

  def full_datetime(time)
    time.strftime("%F %T")
  end

  def time_digest(time)
    now = Time.now
    return time.strftime("%H:%M:%S") if now.day == time.day
    return time.strftime("%m-%d %H:%M") if now.year == time.year
    time.strftime("%F")
  end
end
