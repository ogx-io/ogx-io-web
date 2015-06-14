class Notification::Comment < Notification::Base

  belongs_to :comment, class_name: "Comment"

  def send_email
    NotificationMailer.comment(self).deliver_later
  end
end