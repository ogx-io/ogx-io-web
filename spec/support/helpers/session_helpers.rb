module Features
  module SessionHelpers
    def sign_up_with(name, nick, email, password, confirmation)
      visit new_user_registration_path
      fill_in 'user_name', with: name
      fill_in 'user_nick', with: nick
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', :with => confirmation
      click_button '注册'
    end

    def signin(name, password)
      visit new_user_session_path
      fill_in 'user_name', with: name
      fill_in 'user_password', with: password
      click_button '登录'
    end
  end
end
