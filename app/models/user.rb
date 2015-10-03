# coding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable,
         :omniauthable, omniauth_providers: [:github]

  ## Database authenticatable
  field :name,              :type => String, :default => ""
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Github user information
  field :github_access_token, :type => String, :default => ""
  field :github_user_name, :type => String, :default => ""
  field :github_id, :type => String, :default => ""

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

  field :status, type: Integer, default: 0 # 0: normal, 1: blocked, 2: deleted
  field :enable_email_notification, type: Boolean, default: false

  field :avatar, type: String # the user's avatar
  mount_uploader :avatar, AvatarUploader

  field :last_visit_ip, type: String
  field :last_visited_at, type: Time
  field :last_comment_at, type: Time
  field :last_post_at, type: Time
  field :last_upload_image_at, type: Time

  validates_presence_of :name, message: I18n.t('mongoid.errors.models.user.attributes.name.blank')
  validates_uniqueness_of :name, message: I18n.t('mongoid.errors.models.user.attributes.name.taken')
  validates_format_of :name, with: /^[a-z0-9_]{4,20}$/, :multiline => true, message: I18n.t('mongoid.errors.models.user.attributes.name.invalid')

  validates_presence_of :nick, message: I18n.t('mongoid.errors.models.user.attributes.nick.blank')
  validates_length_of :nick, maximum: 20, message: I18n.t('mongoid.errors.models.user.attributes.nick.too_long')

  validates_presence_of :email, message: I18n.t('mongoid.errors.models.user.attributes.email.blank')
  validates_format_of :email, with: /^([a-z0-9_\.-]{1,20})@([\da-z\.-]+)\.([a-z\.]{2,6})$/, :multiline => true, message: I18n.t('mongoid.errors.models.user.attributes.email.invalid')

  validates_length_of :intro, maximum: 50, message: I18n.t('mongoid.errors.models.user.attributes.intro.too_long')

  validates_length_of :city, maximum: 20, message: I18n.t('mongoid.errors.models.user.attributes.city.too_long')

  has_and_belongs_to_many :managing_boards, class_name: "Board", inverse_of: :moderators
  has_many :posts, inverse_of: :author
  has_many :elite_posts, :class_name => 'Elite::Post', inverse_of: :author
  has_many :topics
  has_many :comments
  has_many :got_likes, class_name: 'Like', foreign_key: 'author_id', inverse_of: :author
  has_many :blocked_users
  has_many :notifications, class_name: 'Notification::Base', dependent: :delete
  has_many :favorites, inverse_of: :user
  has_one :user_detail, dependent: :delete

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def blog
    Board.where(parent: Node.blog, creator: self).first
  end

  def merged_prs
    if github_id
      MergedPullRequest.where(pr_type: 'GitHub', repos: 'ogx-io/ogx-io-web', remote_user_id: github_id)
    else
      []
    end
  end

  def has_liked?(likable)
    Like.where(user: self, likable: likable).exists?
  end

  def add_favorite(favorable)
    Favorite.create(user: self, favorable: favorable)
  end

  def remove_favorite(favorable)
    self.favorites.where(favorable: favorable).delete
  end

  def favorite_boards
    self.favorites.where(favorable_type: 'Board')
  end

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

  def new_notification_count
    self.notifications.unread.count
  end

  def is_blocked?
    self.status == 1 || self.status == 3
  end

  def can_post?
    if self.last_post_at
      Time.now - self.last_post_at > 3.seconds
    else
      true
    end
  end

  def can_comment?
    if self.last_comment_at
      Time.now - self.last_comment_at > 3.seconds
    else
      true
    end
  end

  def can_upload_image?
    if self.last_upload_image_at
      Time.now - self.last_upload_image_at > 3.seconds
    else
      true
    end
  end

  def binded_github?
    !self.github_access_token.blank?
  end

  def self.from_oauth_github(oauth_data)
    return User.new if oauth_data.blank?
    auth_object = oauth_data
    token = oauth_data["credentials"]["token"]
    info = auth_object["extra"]["raw_info"] #.slice(:login, :avatar_url, :name, :company, :blog, :location, :email, :id)
    ogx_info = {}

    ogx_info[:name] = info["login"]
    ogx_info[:email] = info["email"]
    ogx_info[:nick] = info["name"]
    ogx_info[:website] = info["blog"]
    ogx_info[:city] = info["location"]
    ogx_info[:avatar] = info["avatar_url"]
    ogx_info[:github_id] = info["id"]
    ogx_info[:github_user_name] = info["login"]
    user = User.new
    user.github_access_token = token
    user.name = ogx_info[:name] if user.name.blank?
    user.email = ogx_info[:email] if user.email.blank?
    user.nick = ogx_info[:nick] if user.nick.blank?
    user.website = ogx_info[:website] if user.website.blank?
    user.city = ogx_info[:city] if user.city.blank?
    user.github_id = ogx_info[:github_id]
    user.github_user_name = ogx_info[:github_user_name]
    user
  end

  module GithubBindingStatus
    TOKEN_OWNER_FOUND = 1 # 登录已有账户
    BINDING_FOR_CURRENT_USER = 2 # 为当前账户做绑定
    FOUND_BY_ID = 3 # 没通过token找到用户，却通过github id找到了，意思是token换了，需要更新token
    FOUND_BY_EMAIL = 4 # 发现email使用者是ogx.io用户，为他登录
    REGISTER_NEW_USER = 5 # 为这个github账户创建新ogx.io账号
    CURRENT_USER_IS_NOT_TOKEN_OWNER = 6 # 找到了token所有者，却不是当前用户，意思是这个github被绑定了其他账号，无法绑定
    FOUND_BY_EMAIL_BUT_BINDED_GITHUB = 7 # 通过email找到了一个ogx.io用户，但是这个用户绑定了其他的github账号
    FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB = 8 # 通过email找到了一个用户，这用户还没绑定github，为当前这个email不对称的用户绑定是可以的
    FOUND_BY_ID_BUT_BINDED_GITHUB = 9 # 通过id找到了一个用户，但是绑定了其他github
    TOKEN_OWNER_IS_CURRENT_USER = 10 # 已经绑定了，不必再绑定
    TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN = 11 # 用户已经绑定不必再绑定，但是数据的token旧了要更新
  end

  def self.github_token_status(token, gu_info, cur_user)
    token_owner = User.where(github_access_token: token).first

    # 通过token找到了用户，这个session尚没有用户登录，为他登录
    if token_owner && !cur_user
      return GithubBindingStatus::TOKEN_OWNER_FOUND
    end

    # 如果current user存在，就是说明用户已经登陆，用户要绑定
    if cur_user && token_owner
      # 通过token找到的用户就是登录的用户，不需要再绑定
      if token_owner == cur_user
        return  GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER
      # 当前用户想要绑定的github账号被绑定了
      elsif token_owner != cur_user
        return  GithubBindingStatus::CURRENT_USER_IS_NOT_TOKEN_OWNER
      end
    end

    # 没有通过token找到用户，通过id寻找
    # 这种情况很罕见，因为github token不会过期，但是scope范围增加的时候，可能会触发

    github_id_owner = User.where(github_id: gu_info[:id]).first

    # 通过github id 找到了一个用户，意味着这个人的token变了
    if github_id_owner && !cur_user
      return  GithubBindingStatus::FOUND_BY_ID
    elsif github_id_owner && cur_user
      if github_id_owner == cur_user
        return GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN
      elsif github_id_owner != cur_user
        return GithubBindingStatus::FOUND_BY_ID_BUT_BINDED_GITHUB
      end
    end

    # 没有通过id找到用户，这次用email寻找

    email_owner = User.where(email: gu_info[:email]).first

    # 这种情况是很常见的，用户用同一个email注册了ogx.io跟github，但是没有绑定关系
    # 自动绑定，然后登录
    if email_owner && !cur_user
      return GithubBindingStatus::FOUND_BY_EMAIL
    elsif email_owner && cur_user
      if email_owner == cur_user
        # 这种情况如果出现，一定是过去的bug，他的确绑定了，更新用户token吧
        if cur_user.binded_github?
          return GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN
        # 这种情况，用户使用同一个email注册两个账号，做绑定
        else
          return GithubBindingStatus::BINDING_FOR_CURRENT_USER
        end
      # 同一个用户，用a邮箱注册github和账号b，c邮箱注册账号d，要用账号d绑定github，给他绑定
      elsif email_owner != cur_user
        if email_owner.binded_github?
          return GithubBindingStatus::FOUND_BY_EMAIL_BUT_BINDED_GITHUB
        else
          return GithubBindingStatus::FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB
        end
      end
    end

    # 通过github数据，彻底没找到这个用户
    if cur_user
      return GithubBindingStatus::BINDING_FOR_CURRENT_USER
    else
      return GithubBindingStatus::REGISTER_NEW_USER
    end

    # 相当于default，希望程序别执行到这里，不然就是潜在bug
    return GithubBindingStatus::REGISTER_NEW_USER
  end
end
