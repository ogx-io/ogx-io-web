class Notification::Mention < Notification::Base

  belongs_to :mentionable, polymorphic: true

  after_create :send_email

  def send_email
    if mentionable.class == Comment
      NotificationMailer.comment_mention(self.id.to_s).deliver_later
    end
    if mentionable.class == Post
      NotificationMailer.post_mention(self.id.to_s).deliver_later
    end
  end
end
