module ApplicationHelper

  class ::NilClass
    def method_missing(name)
      nil
    end
  end

  def user_show_name(user)
    user.nick ? h(user.nick) : user.name
  end

  def user_link(user)
    if user
      link_to(user_show_name(user), show_user_path(user.name), class: 'user-link', title: "@#{user.name}").html_safe
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

  def pr_avatar(pr, size = 40)
    local_user = pr.local_user
    if local_user
      avatar(local_user, size)
    else
      link_to pr.remote_user_link, target: '_blank' do
        content_tag :div, class: 'avatar', style: "max-width: #{size}px;max-height: #{size}px;" do
          image_tag(pr.remote_user_avatar, alt: '', title: pr.remote_user_name)
        end
      end
    end
  end

  def pr_author(pr)
    local_user = pr.local_user
    if local_user
      user_link(local_user)
    else
      link_to(pr.remote_user_name, pr.remote_user_link, class: 'user-link', target: '_blank').html_safe
    end
  end

  def full_datetime(time)
    time.strftime("%F %T")
  end

  def time_digest(time)
    "<abbr class=\"timeago\" title=\"#{time.strftime("%FT%T%:z")}\"></abbr>".html_safe
  end

  def time_date(time)
    "<span class\"time-date\" title=\"#{time.strftime("%T")}\">#{time.strftime("%F")}</span>".html_safe
  end

  def sanitize_digest(body)
    truncate(sanitize(body, tags: %w()), length: 140)
  end

  def sanitize_post(body)
    sanitize body, :tags => %w(p br img h1 h2 h3 h4 blockquote pre code b i strong em strike del u a ul ol li span), :attributes => %w(href src class title alt target rel style)
  end

  def sanitize_comment(body)
    sanitize body, :tags => %w(p br b i strong em strike u a span img), :attributes => %w(href src class title alt target rel style)
  end

  def sanitize_self_intro(body)
    sanitize body, :tags => %w(p br b i strong em strike u a span img), :attributes => %w(href src class title alt target rel style)
  end

  def elite_breadcrumbs(elite_node)
    result = []
    elite_node.parents.reverse.each do |p|
      name = p.layer == 0 ? 'elites' : p.name
      result.push(link_to(name, elite_category_path(p)))
    end
    result
  end

  def pretty_path_for_node(node)
    if node.is_blog?
      show_user_blog_path(node.creator.name)
    else
      paths = node.full_path.split('/')
      paths[0] = ''
      paths.join('/')
    end
  end

  def get_post_draft_key(post, type)
    if current_user
      if post.new_record?
        post.parent ? "draft_user_#{current_user.id.to_s}_reply_to_#{post.parent.id.to_s}_type_#{type}" : "draft_user_#{current_user.id.to_s}_board_#{post.board.id.to_s}_new_post_type_#{type}"
      else
        "draft_user_#{current_user.id.to_s}_update_post_#{post.id.to_s}_type_#{type}"
      end
    else
      ''
    end
  end
end
