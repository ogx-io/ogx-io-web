class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'notifications'

  field :read, default: false
  belongs_to :user

  scope :unread, -> { where(read: false) }

  def set_read
    self.update_attribute(:read, true)
  end
end
