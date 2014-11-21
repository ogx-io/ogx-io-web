namespace :data do

  desc "Set replied_at field for Topic model"
  task set_replied_at: :environment do
    Topic.all.each do |topic|
      if topic.posts.desc(:created_at).first
        topic.replied_at = topic.posts.desc(:created_at).first.created_at
        topic.save
      end
    end
  end

end
