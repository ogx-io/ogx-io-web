module ApplicationHelper

  def user_link(user)
    if user
      return link_to(user.name, user).html_safe
    else
      '已注销'.html_safe
    end
  end

  def full_user_link(user)
    if user
      return (link_to(user.name, user) + "(@#{user.name})").html_safe
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
    image_tag(url, class: 'avatar')
  end

  def full_datetime(time)
    time.strftime("%F %T")
  end

  def time_digest(time)

  end
end
