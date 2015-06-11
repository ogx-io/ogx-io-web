class NotificationMailer < ApplicationMailer

  def post_reply(id)
    notification = Notification::PostReply.find(id)
    @user = notification.user
    @reply = notification.post
    @author = @reply.author
    @post = notification.post.parent
    @author_name = @author.nick ? @author.nick : @author.name
    mail to: @user.email, subject: I18n.t('notifications.mailer.post_reply.subject', author_name: @author_name, title: @post.title)
  end
end
