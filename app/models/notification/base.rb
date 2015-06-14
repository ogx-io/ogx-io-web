class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  include GlobalID::Identification

  store_in collection: 'notifications'

  field :read, default: false
  belongs_to :user

  scope :unread, -> { where(read: false) }

  after_create :check_email_notification

  def set_read
    self.update_attribute(:read, true)
  end

  def check_email_notification
    send_email if user.enable_email_notification
  end
end
