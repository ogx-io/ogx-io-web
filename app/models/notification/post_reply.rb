class Notification::PostReply < Notification::Base

  belongs_to :post

  def send_email
    NotificationMailer.post_reply(self.id.to_s).deliver_later
  end
end
