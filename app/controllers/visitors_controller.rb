class VisitorsController < ApplicationController

  layout 'admin', only: [:about]

  def index
    @topics = Topic.normal.desc(:replied_at).limit(30)
  end

  def merged_prs
    @merged_pull_requests = MergedPullRequest.where(pr_type: 'GitHub', repos: 'ogx-io/ogx-io-web').desc(:merged_at)
  end

  def about
    @site_info = SiteInfo.get_instance
  end
end
