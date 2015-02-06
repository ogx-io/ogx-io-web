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
    if session['mongoid.auto_increment_ids'].find(_id: 'nodes').count == 0
      session['mongoid.auto_increment_ids'].insert(_id: 'nodes', c: Node.all.count)
    else
      session['mongoid.auto_increment_ids'].find(_id: 'nodes').update(c: Node.all.count)
    end
    session['mongoid.auto_increment_ids'].find(_id: 'boards').remove_all
  end

  desc "add the root node to the node tree"
  task add_root_node: :environment do
    Category.create(name: 'root', path: 'root') unless Node.where(path: 'root').exists?
    Node.all.each do |node|
      unless node.path.start_with?('root')
        puts node.path
        node.path = 'root/' + node.path
        node.save
      end
    end
  end

  desc "initialize the elite category for the boards"
  task init_elite_category: :environment do
    Board.all.each do |board|
      root = board.elite_root
      puts root.board.name
    end
  end
end
