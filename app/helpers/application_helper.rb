module ApplicationHelper

  def user_link(user)
    if user
      return link_to(user.name, user).html_safe
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
end
