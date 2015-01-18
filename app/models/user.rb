class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  ## Database authenticatable
  field :name,              :type => String, :default => ""
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  Roles = [:user, :admin]
  enum :role, Roles, default: :user

  ## User Info
  field :nick, type: String  # a user will be displayed as 'nick(@name)'
  field :intro, type: String # a short introduction of a user
  field :city, type: String # the city which the user is living
  field :website, type: String # the user's personal website

  field :avatar, type: String # the user's avatar
  mount_uploader :avatar, AvatarUploader

  field :last_comment_at, type: Time
  field :last_post_at, type: Time
  field :last_upload_image_at, type: Time

  validates_presence_of :name, message: "请输入用户名"
  validates_uniqueness_of :name, message: "该用户名已存在"
  validates_format_of :name, with: /[a-z0-9_]{4,20}/, message: "格式不对"

  validates_presence_of :nick, message: "请输入昵称"
  validates_length_of :nick, maximum: 20, message: '昵称太长了'

  validates_presence_of :email, message: "请输入邮件地址"
  validates_format_of :email, with: /([a-z0-9_\.-]{1,20})@([\da-z\.-]+)\.([a-z\.]{2,6})/, message: "请输入正确的邮件地址"

  validates_length_of :intro, maximum: 50, message: '个人简介太长了'

  validates_length_of :city, maximum: 20, message: '输入的城市名称太长了'

  has_and_belongs_to_many :managing_boards, class_name: "Board", inverse_of: :moderators
  has_many :posts, inverse_of: :author
  has_many :topics
  has_many :blocked_users
  has_many :notifications, class_name: 'Notification::Base', dependent: :delete

  def get_avatar(size=70)
    if self.avatar.blank?
      "#{Rails.application.secrets.avatar_host}/avatar/" + Digest::MD5.hexdigest(self.email) + '?s=' + size.to_s + '&d=retro'
    else
      "#{self.avatar.url}?imageView2/0/w/#{size}/h/#{size}"
    end
  end

  def get_nick
    self.nick ? self.nick : self.name
  end

  def can_post?
    if self.last_post_at
      Time.now - self.last_post_at > 1.minute
    else
      true
    end
  end

  def can_comment?
    if self.last_comment_at
      Time.now - self.last_comment_at > 5.seconds
    else
      true
    end
  end

  def can_upload_image?
    if self.last_upload_image_at
      Time.now - self.last_upload_image_at > 5.seconds
    else
      true
    end
  end
end
