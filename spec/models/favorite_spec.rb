require 'rails_helper'

RSpec.describe Favorite, type: :model do

  it { is_expected.to have_field(:user_id).of_type(Object) }
  it { is_expected.to have_field(:favorable_id).of_type(Object) }
  it { is_expected.to have_field(:favorable_type).of_type(String) }

end
