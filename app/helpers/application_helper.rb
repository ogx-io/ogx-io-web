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
    return time.strftime("%H:%M:%S") if now.day == time.day
    return time.strftime("%m-%d %H:%M") if now.year == time.year
    time.strftime("%F")
  end

  def markdown(text)
    options = {
        :autolink => false,
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :hard_wrap => true,
        :strikethrough => true
    }
    markdown = Redcarpet::Markdown.new(HTMLwithCodeRay, options)
    markdown.render(text).html_safe
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      language ||= 'text'
      CodeRay.scan(code, language).div(:tab_width => 2)
    end
  end

  def sanitize_post(body)
    sanitize body, :tags => %w(div p br img h1 h2 h3 h4 blockquote pre code b i strong em strike del u a ul ol li span), :attributes => %w(href src class title alt target rel style)
  end

end
