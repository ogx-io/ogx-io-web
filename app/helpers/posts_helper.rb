module PostsHelper

  def default_reply_title(post)
    if post
      (post.title.start_with?('Re:') ? '' : 'Re: ') + post.title
    else
      ''
    end
  end
end
