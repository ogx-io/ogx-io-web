class Like
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :likable, polymorphic: true
  belongs_to :author, class_name: 'User', inverse_of: :got_likes

  index({user_id: 1, likable_type: 1, likable_id: 1}, {unique: true, drop_dups: true})

  validate :check_user

  before_create :set_author

  def set_author
    self.author = self.likable.author
  end

  def check_user
    if self.likable.author == self.user
      errors.add(:user_id, I18n.t('mongoid.errors.models.like.attributes.user_id.can_not_be_author'))
    end
  end
end
