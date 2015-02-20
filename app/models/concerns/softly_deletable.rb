module SoftlyDeletable
  extend ActiveSupport::Concern

  included do
    field :d, as: :deleted, type: Integer, default: 0 # 0: normal, 1:deleted by user, 2: deleted by admin
    belongs_to :deleter, class_name: "User"
    belongs_to :resumer, class_name: "User"
    scope :normal, -> { where(deleted: 0) }
    scope :deleted, -> { where(deleted: {'$gt' => 0}) }
  end

  def deleted?
    self.deleted > 0
  end

  def delete_by(user)
    if self.author == user
      self.deleted = 1
    else
      self.deleted = 2
    end
    self.deleter = user
    self.save
    self.__send__ :after_delete_by, user if self.respond_to? :after_delete_by
  end

  def resume_by(user)
    self.deleted = 0
    self.resumer = user
    self.save
    self.__send__ :after_resume_by, user if self.respond_to? :after_resume_by
  end
end