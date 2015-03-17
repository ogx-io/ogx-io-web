describe User do

  let(:user) { create(:user, email: 'user@example.com') }

  it "#email returns a string" do
    expect(user.email).to match 'user@example.com'
  end

  it 'has many favorites' do
    expect(user).to have_many(:favorites)
  end

end
