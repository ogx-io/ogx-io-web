shared_context 'all roles' do
  let(:admin) { create(:user, :admin) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:another_user) { create(:user) }
  let(:board) { create(:board) }
  let(:old_post) { create(:post, author: author, board: board) }

  before do
    board.moderators << moderator
  end
end

shared_examples 'only for admin' do |page|
  it 'succeeds when the current user is admin' do
    sign_in :user, admin
    get page
    expect(response).to be_success
    expect(request.flash[:error]).to be_blank
  end

  it 'fails when the current user is another user' do
    sign_in :user, another_user
    get page
    expect(response).not_to be_success
    expect(request.flash[:error]).not_to be_blank
  end
end

shared_examples 'for admin and moderator' do |page|
  it 'succeeds when the current user is admin' do
    sign_in :user, admin
    get page
    expect(response).to be_success
    expect(request.flash[:error]).to be_blank
  end

  it 'succeeds when the current user is moderator' do
    sign_in :user, moderator
    get page
    expect(response).to be_success
    expect(request.flash[:error]).to be_blank
  end

  it 'fails when the current user is a normal user' do
    sign_in :user, another_user
    get page
    expect(response).not_to be_success
    expect(request.flash[:error]).not_to be_blank
  end
end