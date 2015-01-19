module Mentionable
  extend ActiveSupport::Concern

  included do
    field :mentioned_user_ids, type: Array, default: []
    has_many :notification_mentions, as: :mentionable, class_name: 'Notification::Mention'

    after_save :send_mention_notifications
  end

  def send_mention_notifications
    names = self.body.scan(/@([a-z0-9_]{4,20})/).flatten
    if names.any?
      user_ids = User.where(:name.in => names).limit(5).collect { |u| u.id }
      uids = user_ids - self.mentioned_user_ids
      uids.each do |uid|
        Notification::Mention.create(user_id: uid, mentionable: self)
      end

      self.class.skip_callback(:save, :after, :send_mention_notifications)
      update_attribute(:mentioned_user_ids, self.mentioned_user_ids + uids)
      self.class.set_callback(:save, :after, :send_mention_notifications)
    end
  end

end