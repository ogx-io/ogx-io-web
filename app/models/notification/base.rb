class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'notifications'

  field :read, default: false
  belongs_to :user

  scope :unread, -> { where(read: false) }

end
