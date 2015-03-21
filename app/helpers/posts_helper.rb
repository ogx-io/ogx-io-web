module PostsHelper

  def default_reply_title(post)
    (post.title.start_with?('Re:') ? '' : 'Re: ') + post.title
  end
end
