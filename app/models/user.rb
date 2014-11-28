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
  field :nick, type: String, default: ""  # a user will be displayed as 'nick(@name)'
  field :gender, type: Integer

  validates_presence_of :name, message: "请输入用户名"
  validates_uniqueness_of :name, message: "该用户名已存在"
  validates_format_of :name, with: /[a-z0-9_]{4,20}/, message: "格式不对"

  validates_presence_of :nick, message: "请输入昵称"
  validates_length_of :nick, maximum: 20, message: '昵称太长了'

  validates_presence_of :email, message: "请输入邮件地址"
  validates_format_of :email, with: /([a-z0-9_\.-]{1,20})@([\da-z\.-]+)\.([a-z\.]{2,6})/, message: "请输入正确的邮件地址"

  validates_presence_of :gender, message: "请选择性别"

  validates_presence_of :password, message: "密码不能为空"

  validates_presence_of :password_confirmation, message: "密码确认不能为空"

  has_many :board_applications, inverse_of: :applier
  has_and_belongs_to_many :managing_boards, class_name: "Board", inverse_of: :moderators
  has_many :posts, inverse_of: :author
  has_many :blocked_users

  def get_avatar(size=70)
    'http://www.gravatar.com/avatar/' + Digest::MD5.hexdigest(self.email) + '?r=G&s=' + size.to_s
  end
end
