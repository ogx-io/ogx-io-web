class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  field :image, type: String

  belongs_to :user

  after_create :update_user

  mount_uploader :image, ImageUploader

  def update_user
    self.user.update(last_upload_image_at: self.created_at)
  end
end
