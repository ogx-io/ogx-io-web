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
      post.body_html = MarkdownTopicConverter.format(post.body, post.topic)
      post.save
    end
  end

  desc "reset the body_html field of the comments"
  task set_comment_body_html: :environment do
    Comment.all.each do |comment|
      comment.body_html = MarkdownTopicConverter.format(comment.body, comment.topic)
      comment.save
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

  desc "remove user collecting boards"
  task remove_user_collecting_boards: :environment do
    User.each { |user| user.unset(:collecting_board_ids) }
  end

  desc "correct the likes count of every user"
  task set_author_of_like: :environment do
    Like.each do |like|
      like.update(author_id: like.likable.author_id)
    end
  end

  desc 'fetch the merged pull requests from GitHub'
  task fetch_merged_pull_requests: :environment do
    require 'net/http'
    uri = URI('https://api.github.com/repos/ogx-io/ogx-io-web/pulls?state=closed')
    body = Net::HTTP.get(uri)
    pull_requests = JSON.parse(body)
    pull_requests.each do |pr|
      unless pr['merged_at'].blank?
        remote_id = pr['id'].to_s
        remote_user_id = pr['user']['id'].to_s
        raw_info = pr.to_json
        merged_at = Time.parse(pr['merged_at'])
        remote_created_at = Time.parse(pr['created_at'])
        title = pr['title']
        link = pr['html_url']
        remote_user_name = pr['user']['login']
        remote_user_link = pr['user']['html_url']
        remote_user_avatar = pr['user']['avatar_url']
        if MergedPullRequest.where(pr_type: 'GitHub', remote_id: remote_id).exists?
          db_pr = MergedPullRequest.where(pr_type: 'GitHub', remote_id: remote_id).first
          db_pr.remote_user_id = remote_user_id
          db_pr.raw_info = raw_info
          db_pr.merged_at = merged_at
          db_pr.remote_created_at = remote_created_at
          db_pr.title = title
          db_pr.link = link
          db_pr.remote_user_name = remote_user_name
          db_pr.remote_user_link = remote_user_link
          db_pr.remote_user_avatar = remote_user_avatar
          db_pr.save
        else
          MergedPullRequest.create!(pr_type: 'GitHub',
                                    remote_id: remote_id,
                                    remote_user_id: remote_user_id,
                                    raw_info: raw_info,
                                    repos: 'ogx-io/ogx-io-web',
                                    merged_at: merged_at,
                                    remote_created_at: remote_created_at,
                                    title: title,
                                    link: link,
                                    remote_user_name: remote_user_name,
                                    remote_user_link: remote_user_link,
                                    remote_user_avatar: remote_user_avatar)
        end
      end
    end
  end

end
