require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it { is_expected.to have_field(:user_id).of_type(Object) }
  it { is_expected.to have_field(:favorable_id).of_type(Object) }
  it { is_expected.to have_field(:favorable_type).of_type(String) }

  let(:user) { create(:user) }
  let(:board) { create(:board) }

  it 'should be unique' do
    Favorite.create(user: user, favorable: board)
    expect {
      Favorite.create(user: user, favorable: board)
    }.to raise_error
  end
end
