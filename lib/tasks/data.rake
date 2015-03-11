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

  desc "change primary key's type to object id"
  task change_to_object_id: :environment do
    class IdGenerator
      include Mongoid::Document
      def self.get_new_object_id
        g = self.create
        g.id
      end
    end

    relation_hash = {
        User => {
            Topic => {
                user_id: 0,
                locker_id: 0,
                unlocker_id: 0,
                deleter_id: 0,
                resumer_id: 0
            },
            Post => {
                author_id: 0,
                mentioned_user_ids: 1,
                deleter_id: 0,
                resumer_id: 0
            },
            Picture => {
                user_id: 0
            },
            Comment => {
                user_id: 0,
                mentioned_user_ids: 1,
                deleter_id: 0,
                resumer_id: 0
            },
            Board => {
                creator_id: 0,
                moderator_ids: 1
            },
            BlockedUser => {
                user_id: 0,
                blocker_id: 0
            },
            Notification::Base => {
                user_id: 0
            },
            Elite::Node => {
                moderator_id: 0,
                deleter_id: 0,
                resumer_id: 0
            },
            Elite::Post => {
                author_id: 0
            }
        },
        Topic => {
            Post => {
                topic_id: 0
            },
            Elite::Post => {
                topic_id: 0
            }
        },
        Post => {
            Comment => {
                commentable: 2
            },
            Post => {
                parent_id: 0
            },
            Notification::PostReply => {
                post_id: 0
            },
            Notification::Mention => {
                mentionable: 2
            },
            Elite::Post => {
                original_id: 0
            }
        },
        Picture => {
        },
        Node => {
            User => {
                managing_board_ids: 1,
                collecting_board_ids: 1
            },
            Topic => {
                board_id: 0
            },
            Post => {
                board_id: 0
            },
            Node => {
                parent_id: 0
            },
            Comment => {
                board_id: 0
            },
            BlockedUser => {
                blockable: 2
            },
            Elite::Node => {
                board_id: 0
            }
        },
        Comment => {
            Comment => {
                commentable: 2
            },
            Notification::Mention => {
                mentionable: 2
            },
            Notification::Comment => {
                comment_id: 0
            }
        },
        BlockedUser => {
        },
        Notification::Base => {
        },
        Elite::Node => {
            Elite::Node => {
                parent_id: 0
            }
        }
    }

    relation_hash.each do |klass, relations|
      p '#' + klass.to_s
      old_id_map = {}
      klass.all.each do |item|
        # p item
        collection = klass.collection
        object_id = IdGenerator.get_new_object_id
        old_id = item.id
        old_id_map[old_id] = object_id

        rec = collection.find(_id: old_id).one
        rec["_id"] = object_id
        collection.insert(rec)
        collection.find(_id: old_id).remove
      end

      relations.each do |klass2, attributes|
        # p klass2
        klass2.all.each do |obj|
          # p obj
          attributes.each do |attr, type|
            # p attr, type
            if type == 0
              old_id = obj.__send__(attr)
              # p old_id_map[old_id]
              obj.update_attribute(attr, old_id_map[old_id])
            end
            if type == 1
              old_ids = obj.__send__(attr)
              new_ids = old_ids.collect { |id| old_id_map[id] }
              obj.update_attribute(attr, new_ids)
            end
            if type == 2
              klass_type = obj.__send__(attr.to_s + '_type')
              if klass_type.constantize.new.is_a?(klass)
                puts klass.to_s + '|' + klass_type
                old_id = obj.__send__(attr.to_s + '_id')
                puts "#{attr.to_s}  #{old_id} : #{old_id_map[old_id]}"
                obj.update_attribute(attr.to_s + '_id', old_id_map[old_id])
              end
            end
          end
        end
      end
    end
  end
end
