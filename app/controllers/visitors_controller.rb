class VisitorsController < ApplicationController

  def index
    @topics = Topic.normal.desc(:replied_at).limit(30)
  end

  def merged_prs
    @merged_pull_requests = MergedPullRequest.where(pr_type: 'GitHub', repos: 'ogx-io/ogx-io-web')
  end
end
