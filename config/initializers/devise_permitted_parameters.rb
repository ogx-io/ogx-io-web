module DevisePermittedParameters
  extend ActiveSupport::Concern

  included do
    before_filter :configure_permitted_parameters
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :email << :nick << :gender << :github_access_token << :github_id << :github_user_name
    devise_parameter_sanitizer.for(:account_update) << :name << :email << :nick << :intro << :city << :avatar << :website
  end

end

DeviseController.send :include, DevisePermittedParameters
