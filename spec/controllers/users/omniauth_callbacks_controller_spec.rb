require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe "handles github callback" do
    pending()
    # github_oauth_data = {
    #   "credentials" => { "token" => "abcde" },
    #   "extra" => { "raw_info" => {
    #      "login" => "username",
    #      "email" => "email@example.com",
    #      "name" => "My Name",
    #      "blog" => "blog.example.com",
    #      "location" => "Beijing, China",
    #      "avatar_url" => "http://www.baidu.com",
    #      "id" => "12345"
    # } } }
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    # @request.env['omniauth.auth'] = github_oauth_data
    # get :github
    # expect(response).to be_success

  end
end
