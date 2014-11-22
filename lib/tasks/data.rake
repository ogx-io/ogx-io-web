namespace :data do

  desc "Set replied_at field for Topic model"
  task set_topic_replied_at: :environment do
    Topic.all.each do |topic|
      if topic.posts.desc(:created_at).first
        topic.replied_at = topic.posts.desc(:created_at).first.created_at
        topic.save
      end
    end
  end

  desc "Set deleted status for Post model"
  task set_post_deleted_status: :environment do
    Post.all.each do |post|
      post.deleted = 0
      post.save
    end
  end

  desc "Set deleted status for Topic model"
  task set_topic_deleted_status: :environment do
    Topic.all.each do |topic|
      topic.deleted = 0
      topic.save
    end
  end

end
