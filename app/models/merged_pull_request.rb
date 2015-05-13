class MergedPullRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :pr_type, type: String
  field :remote_id, type: String
  field :remote_user_id, type: String
  field :raw_info, type: String
  field :repos, type: String
  field :remote_created_at, type: Time
  field :merged_at, type: Time
  field :title, type: String
  field :link, type: String
  field :remote_user_name, type: String
  field :remote_user_link, type: String
  field :remote_user_avatar, type: String

  def local_user
    user = nil
    if pr_type == 'GitHub'
      user = User.find_by(github_id: remote_user_id)
    end
    return user
  rescue
    return nil
  end

end
