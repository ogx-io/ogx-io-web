require 'rails_helper'

RSpec.describe UserDetail, type: :model do
  it { is_expected.to have_field(:intro).of_type(String) }
  it { is_expected.to belong_to(:user) }

  it 'can convert markdown to html' do
    ud = build(:user_detail)
    ud.intro = '## Head'
    ud.save
    ud.reload
    expect(ud.intro_html).to eq('<h2>Head</h2>')
  end
end
