require 'rails_helper'

RSpec.describe MergedPullRequest, type: :model do
  it { is_expected.to have_field(:pr_type).of_type(String) }
  it { is_expected.to have_field(:remote_user_id).of_type(String) }
  it { is_expected.to have_field(:raw_info).of_type(String) }
  it { is_expected.to have_field(:repos).of_type(String) }
  it { is_expected.to have_field(:merged_at).of_type(Time) }
end
