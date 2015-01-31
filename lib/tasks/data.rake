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

  desc "Set the parent_ids for the old replying post"
  task set_post_parent_ids: :environment do
    Post.all.each do |post|
      if post.floor != 0 && !post.parent
        post.parent = post.topic.posts.first
        post.save
      end
    end
  end

  desc "reset the body_html field of the posts"
  task set_post_body_html: :environment do
    Post.all.each do |post|
      post.body_html = MarkdownConverter.convert(post.body)
      post.save
    end
  end

  desc "load the board objects to the nodes collection"
  task change_board_to_node: :environment do
    session = Board.mongo_session
    session[:boards].find().update_all("$set" => {_type: "Board"})
    session[:boards].rename('nodes')
    count = session['mongoid.auto_increment_ids'].find(:_id => 'boards').one['c']
    session['mongoid.auto_increment_ids'].find(:_id => 'nodes').update("$set" => {c: count})
    session['mongoid.auto_increment_ids'].find(:_id => 'boards').remove_all
  end
end
