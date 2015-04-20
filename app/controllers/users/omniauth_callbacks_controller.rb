# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    # This object is an instance of class OmniAuth::AuthHash
    auth_object = env["omniauth.auth"]
    token = auth_object.credentials.token
    github_user_info = auth_object.extra.raw_info.slice(:login, :avatar_url, :name, :company, :blog, :location, :email, :id)
    status = User.github_token_status(token, github_user_info, current_user)
    puts "STATUS: #{status}"
    case status
    # 这种情况，注册新用户
    when User::GithubBindingStatus::REGISTER_NEW_USER
      session["devise.github_data"] = auth_object
      redirect_to new_user_registration_path
    # 这种情况，为用户登录
    when User::GithubBindingStatus::TOKEN_OWNER_FOUND
      token_owner = User.where(github_access_token: token).first
      sign_in(:user, token_owner)
      redirect_to root_path
    # 这种情况，为用户更新github信息，然后登录
    when User::GithubBindingStatus::FOUND_BY_ID
      github_id_owner = User.where(github_id: github_user_info[:id]).first
      github_id_owner.github_access_token = token
      github_id_owner.github_id = github_user_info[:id]
      github_id_owner.github_user_name = github_user_info[:login]
      github_id_owner.save!
      sign_in(:user, github_id_owner)
      redirect_to root_path
    # 这种情况，为用户绑定，然后登录
    when User::GithubBindingStatus::FOUND_BY_EMAIL
      email_owner = User.where(email: github_user_info[:email]).first
      email_owner.github_access_token = token
      email_owner.github_id = github_user_info[:id]
      email_owner.github_user_name = github_user_info[:login]
      email_owner.save!
      sign_in(:user, email_owner)
      redirect_to root_path
    # 这种情况，为当前用户做绑定
    when User::GithubBindingStatus::BINDING_FOR_CURRENT_USER
      current_user.github_access_token = token
      current_user.github_id = github_user_info[:id]
      current_user.github_user_name = github_user_info[:login]
      current_user.save!
      redirect_to edit_user_registration_path
    # 这种情况，告诉用户，你要绑定的github被别的账号绑定了
    when User::GithubBindingStatus::CURRENT_USER_IS_NOT_TOKEN_OWNER
      flash[:error] = '这个github账号已经被绑定了'
      redirect_to edit_user_registration_path
    # 这种情况，告诉用户，你要绑定的github被别的账号绑定了
    # 然而，还要更新一下那个用户的信息
    when User::GithubBindingStatus::FOUND_BY_ID_BUT_BINDED_GITHUB
      github_id_owner = User.where(github_id: github_user_info[:id]).first
      github_id_owner.github_access_token = token
      github_id_owner.github_user_name = github_user_info[:login]
      github_id_owner.save!
      flash[:error] = '这个github账号已经被绑定了'
      redirect_to edit_user_registration_path
    # 这种情况，在神级bug的情况下会出现，为他绑定就好了
    when User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_BINDED_GITHUB
      current_user.github_access_token = token
      current_user.github_id = github_user_info[:id]
      current_user.github_user_name = github_user_info[:login]
      current_user.save!
      redirect_to edit_user_registration_path
    # 这种情况，可以为他绑定
    when User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB
      current_user.github_access_token = token
      current_user.github_id = github_user_info[:id]
      current_user.github_user_name = github_user_info[:login]
      current_user.save!
      redirect_to edit_user_registration_path
    # 这种情况，告诉用户，你都绑定了，不必再绑定
    when User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER
      flash[:notice] = '您已经绑定了github'
      redirect_to edit_user_registration_path
    # 这种情况，用户已经绑定了，但是保存的信息旧了，应该要更新一下
    when User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN
      current_user.github_access_token = token
      current_user.github_id = github_user_info[:id]
      current_user.github_user_name = github_user_info[:login]
      current_user.save!
      flash[:notice] = '您已经绑定了github'
      redirect_to edit_user_registration_path
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET or POST /users/auth/github
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when omniauth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
