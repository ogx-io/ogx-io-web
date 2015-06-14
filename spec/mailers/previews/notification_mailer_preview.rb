# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def post_reply
    notification = Notification::PostReply.first
    NotificationMailer.post_reply(notification.id.to_s) if notification
  end

  def comment_mention
    notification = Notification::Mention.all.select{|item| item.mentionable.class == Comment}.first
    NotificationMailer.comment_mention(notification.id.to_s) if notification
  end

  def post_mention
    notification = Notification::Mention.all.select{|item| item.mentionable.class == Post}.first
    NotificationMailer.post_mention(notification.id.to_s) if notification
  end

  def comment
    notification = Notification::Comment.first
    NotificationMailer.comment(notification.id.to_s) if notification
  end
end
