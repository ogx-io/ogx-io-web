class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  field :image, type: String

  belongs_to :user
  belongs_to :picturable, polymorphic: true

  mount_uploader :image, ImageUploader
end
