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

  desc "reset the body_html field of the posts"
  task set_post_body_html: :environment do
    Post.all.each do |post|
      post.body_html = MarkdownConverter.convert(post.body)
      post.save
    end
  end

  desc "add the root node to the node tree"
  task add_root_node: :environment do
    unless Node.where(path: 'root').exists?
      root = Category.new(name: 'root', path: 'root')
      root.save(validate: false)
      Node.all.each do |node|
        unless node.path == 'root'
          puts node.path
          node.parent = root
          node.save(validate: false)
        end
      end
    end
  end

  desc "clear all top posts"
  task clear_all_top_posts: :environment do
    Post.update_all(top: 0)
  end

  desc "change _id type to object id"
  task change_to_object_id: :environment do
    class IdGenerator
      include Mongoid::Document
      def self.get_new_object_id
        g = self.create
        g.id
      end
    end

    relations = {
        User => {
            Topic => {
                user_id: false
            },
            Post => {
                author_id: false
            }
        }
    }
  end
end
