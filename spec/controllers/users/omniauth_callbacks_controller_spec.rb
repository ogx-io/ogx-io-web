require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe "handles github callback in these ways: " do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      github_oauth_data = {
        "credentials" => { "token" => "abcde" },
        "extra" => { "raw_info" => {
          "login" => "username",
          "email" => "email@example.com",
          "name" => "My Name",
          "blog" => "blog.example.com",
          "location" => "Beijing, China",
          "avatar_url" => "http://www.baidu.com",
          "id" => "12345"
      } } }
      controller.env = Hashie::Mash.new({"omniauth.auth" => github_oauth_data })
      allow(controller).to receive(:sign_in).and_return true
    end
    it "TOKEN_OWNER_FOUND => root_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::TOKEN_OWNER_FOUND
      expect(controller).to receive(:sign_in).once
      get :github
      expect(response).to redirect_to(root_path)
    end
    it "REGISTER_NEW_USER => new_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::REGISTER_NEW_USER
      get :github
      expect(response).to render_template('devise/registrations/new')
    end
    it "FOUND_BY_ID => root_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::FOUND_BY_ID
      expect(controller).to receive(:sign_in).once
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(response).to redirect_to(root_path)
    end
    it "FOUND_BY_EMAIL => root_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::FOUND_BY_EMAIL
      expect(controller).to receive(:sign_in).once
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(response).to redirect_to(root_path)
    end
    it "BINDING_FOR_CURRENT_USER => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::BINDING_FOR_CURRENT_USER
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "CURRENT_USER_IS_NOT_TOKEN_OWNER => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::CURRENT_USER_IS_NOT_TOKEN_OWNER
      get :github
      expect(flash[:error]).not_to be_empty
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "FOUND_BY_ID_BUT_BINDED_GITHUB => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::FOUND_BY_ID_BUT_BINDED_GITHUB
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(flash[:error]).not_to be_empty
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "FOUND_BY_EMAIL_BUT_BINDED_GITHUB => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_BINDED_GITHUB
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "TOKEN_OWNER_IS_CURRENT_USER => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER
      get :github
      expect(flash[:notice]).not_to be_empty
      expect(response).to redirect_to(edit_user_registration_path)
    end
    it "TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN => edit_user_registration_path" do
      allow(User).to receive(:github_token_status).and_return User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN
      expect(controller).to receive(:update_user_with_github_information).once
      get :github
      expect(flash[:notice]).not_to be_empty
      expect(response).to redirect_to(edit_user_registration_path)
    end
  end
end
