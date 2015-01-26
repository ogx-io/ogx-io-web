module ApplicationHelper

  class ::NilClass
    def method_missing(name)
      nil
    end
  end

  def user_link(user)
    if user
      link_to(user.nick ? h(user.nick) : user.name, show_user_path(user.name), class: 'user-link', title: "@#{user.name}").html_safe
    else
      '<span class="user-link">已注销</span>'.html_safe
    end
  end

  def full_user_link(user)
    if user
      (link_to(user.nick ? h(user.nick) : user.name, show_user_path(user.name)) + " <span class=\"user-name\">@#{user.name}</span>".html_safe).html_safe
    else
      '已注销'.html_safe
    end
  end

  def avatar(user, size = 70, with_link = true)
    if user
      url = user.get_avatar(size)

      if with_link
        link_to show_user_path(user.name) do
          content_tag :div, class: 'avatar', style: "max-width: #{size}px;max-height: #{size}px;" do
            image_tag(url, alt: '', title: user.nick ? user.nick : user.name)
          end
        end
      else
        content_tag :div, class: 'avatar', style: "max-width: #{size}px;max-height: #{size}px;" do
          image_tag(url, alt: '', title: user.nick ? user.nick : user.name)
        end
      end
    else
      url = "http://www.gravatar.com/avatar/?s=#{size}&d=retro"
      content_tag :div, class: 'avatar', style: "max-width: #{size}px;max-height: #{size}px;" do
        image_tag(url, alt: '', title: user.nick ? user.nick : user.name)
      end
    end
  end

  def full_datetime(time)
    time.strftime("%F %T")
  end

  def time_digest(time)
    now = Time.now
    diff_seconds = now - time
    str = case diff_seconds
            when 0 .. 59
              "#{ diff_seconds } 秒前"
            when 60 .. (3600-1)
              "#{ (diff_seconds / 60).to_i } 分钟前"
            when 3600 .. (3600 * 24 - 1)
              "#{ (diff_seconds / 3600).to_i } 小时前"
            when (3600 * 24) .. (3600 * 24 * 31)
              "#{ (diff_seconds / (3600 * 24)).to_i } 天前"
            else
              diff_months = (now.year - time.year) * 12 + now.month - time.month
              if time.year == now.year || diff_months < 12
                "#{diff_months} 个月前"
              else
                "#{now.year - time.year} 年前"
              end
          end
    "<span title=\"#{time.strftime("%F %T")}\">#{str}</span>".html_safe
  end

  def sanitize_post(body)
    sanitize body, :tags => %w(p br img h1 h2 h3 h4 blockquote pre code b i strong em strike del u a ul ol li span), :attributes => %w(href src class title alt target rel style)
  end

  def sanitize_comment(body)
    body.gsub!("\n", '<br/>')
    body = auto_link(body, sanitize: false, html: { target: '_blank' })
    sanitize body, :tags => %w(p br b i strong em strike u a span), :attributes => %w(href src class title alt target rel style)
  end

end
