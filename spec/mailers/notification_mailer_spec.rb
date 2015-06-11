require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do

  describe '#post_reply' do
    it 'sends email after create a post reply notification' do
      notification = create(:notification_post_reply)
      expect(ActionMailer::Base.deliveries).not_to be_empty

      email = ActionMailer::Base.deliveries.last
      expect(email.to[0]).to eq(notification.user.email)

      email_subject = I18n.t('notifications.mailer.post_reply.subject', author_name: notification.post.author.nick, title: notification.post.parent.title)
      expect(email.subject).to eq(email_subject)

      reply = notification.post
      expect(email.body.to_s).to match(show_topic_post_url(reply.topic.id, reply.id))
    end
  end

end
