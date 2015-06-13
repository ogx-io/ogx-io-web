require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do

  before do
    ActionMailer::Base.deliveries.clear
  end

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

  describe '#comment_mention' do
    it 'sends email after create a comment mention notification' do
      notification = create(:notification_mention, mentionable: create(:comment))
      expect(ActionMailer::Base.deliveries).not_to be_empty

      email = ActionMailer::Base.deliveries.last
      expect(email.to[0]).to eq(notification.user.email)

      email_subject = I18n.t('notifications.mailer.mention.comment.subject', comment_author: notification.mentionable.user.nick, title: notification.mentionable.commentable.title)
      expect(email.subject).to eq(email_subject)

      expect(email.body.to_s).to match(notification.mentionable.body_html)
    end
  end

  describe '#post_mention' do
    it 'sends email after create a post mention notification' do
      notification = create(:notification_mention, mentionable: create(:post))
      expect(ActionMailer::Base.deliveries).not_to be_empty

      email = ActionMailer::Base.deliveries.last
      expect(email.to[0]).to eq(notification.user.email)

      email_subject = I18n.t('notifications.mailer.mention.post.subject', post_author: notification.mentionable.author.nick, title: notification.mentionable.title)
      expect(email.subject).to eq(email_subject)

      post = notification.mentionable
      expect(email.body.to_s).to match(post.body_html)
    end
  end

  describe '#comment' do
    it 'sends email after create a comment notification' do
      notification = create(:notification_comment)
      expect(ActionMailer::Base.deliveries).not_to be_empty

      email = ActionMailer::Base.deliveries.last
      expect(email.to[0]).to eq(notification.user.email)

      email_subject = I18n.t('notifications.mailer.comment.subject', comment_author: notification.comment.user.nick, title: notification.comment.commentable.title)
      expect(email.subject).to eq(email_subject)

      expect(email.body.to_s).to match(notification.comment.body_html)
    end
  end

end
