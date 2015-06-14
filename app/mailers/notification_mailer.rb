class NotificationMailer < ApplicationMailer

  def post_reply(notification)
    @user = notification.user
    @reply = notification.post
    @reply_author = @reply.author
    @reply_author_name = author_name(@reply_author)
    @post = notification.post.parent
    mail to: @user.email, subject: I18n.t('notifications.mailer.post_reply.subject', author_name: @reply_author_name, title: @post.title)
  end

  def comment_mention(notification)
    @user = notification.user
    @comment = notification.mentionable
    @post = @comment.commentable
    @comment_author = @comment.user
    @comment_author_name = author_name(@comment_author)
    mail to: @user.email, subject: I18n.t('notifications.mailer.mention.comment.subject', comment_author: @comment_author_name, title: @post.title)
  end

  def post_mention(notification)
    @user = notification.user
    @post = notification.mentionable
    @post_author_name = author_name(@post.author)
    mail to: @user.email, subject: I18n.t('notifications.mailer.mention.post.subject', post_author: @post_author_name, title: @post.title)
  end

  def comment(notification)
    @user = notification.user
    @post = notification.comment.commentable
    @comment = notification.comment
    @comment_author = @comment.user
    @comment_author_name = author_name(@comment_author)
    mail to: @user.email, subject: I18n.t('notifications.mailer.comment.subject', comment_author: @comment_author_name, title: @post.title)
  end

  private

  def author_name(author)
    author.nick ? author.nick : author.name
  end
end
