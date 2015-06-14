class Notification::PostReply < Notification::Base

  belongs_to :post

  def send_email
    NotificationMailer.post_reply(self).deliver_later
  end
end
