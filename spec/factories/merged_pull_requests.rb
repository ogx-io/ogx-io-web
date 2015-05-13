FactoryGirl.define do
  factory :merged_pull_request do
    pr_type 'GitHub'
    remote_id '123'
    remote_user_id '123'
    raw_info "A long String"
    repos 'fake-repos'
    remote_created_at Time.now
    merged_at { Time.now }
    title 'Test title'
    link 'http://example.com'
    remote_user_name 'test_user'
    remote_user_link 'http://example.com'
    remote_user_avatar 'http://example.com/avatar.jpg'
  end

end
