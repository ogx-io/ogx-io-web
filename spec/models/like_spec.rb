require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to have_field(:user_id).of_type(Object) }
  it { is_expected.to have_field(:likable_id).of_type(Object) }
  it { is_expected.to have_field(:likable_type).of_type(String) }

  let(:user) { create(:user) }
  let(:post) { create(:post) }

  it 'should be unique' do
    Like.create(user: user, likable: post)
    expect {
      Like.create(user: user, likable: post)
    }.to raise_error
  end
end
