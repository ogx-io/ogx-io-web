# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def post_reply
    notification = Notification::PostReply.first
    NotificationMailer.post_reply(notification.id.to_s) if notification
  end
end
