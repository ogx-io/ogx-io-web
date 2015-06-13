class Notification::Comment < Notification::Base

  belongs_to :comment, class_name: "Comment"

  after_create :send_email

  def send_email
    NotificationMailer.comment(self.id.to_s).deliver_later
  end
end