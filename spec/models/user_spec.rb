describe User do

  let(:user) { create(:user, email: 'user@example.com') }

  it "#email returns a string" do
    expect(user.email).to match 'user@example.com'
  end

  it 'has many favorites' do
    expect(user).to have_many(:favorites)
  end

  it 'constructs with github oauth data' do
    github_oauth_data = {
      "credentials" => { "token" => "abcde" },
      "extra" => { "raw_info" => {
         "login" => "username",
         "email" => "email@example.com",
         "name" => "My Name",
         "blog" => "blog.example.com",
         "location" => "Beijing, China",
         "avatar_url" => "http://www.baidu.com",
         "id" => "12345"
    } } }
    user = User.from_oauth_github(github_oauth_data)
    expect(user.name).to eq('username')
    expect(user.email).to eq('email@example.com')
    expect(user.nick).to eq('My Name')
    expect(user.website).to eq('blog.example.com')
    expect(user.city).to eq('Beijing, China')
    expect(user.github_id).to eq('12345')
    expect(user.github_user_name).to eq('username')
    expect(user.github_access_token).to eq('abcde')
  end

  describe 'estimates github token status: ' do
    before(:each) do
      @github_user = FactoryGirl.create :github_user
      @unbinded_github_user = FactoryGirl.create :unbinded_github_user
      @github_user_2 = FactoryGirl.create :github_user_2
    end
    describe 'when current user is not signed in, ' do
      describe 'if token owner found, ' do
        it 'should return TOKEN_OWNER_FOUND' do
          status = User.github_token_status('abcde', {}, nil)
          expect(status).to be(User::GithubBindingStatus::TOKEN_OWNER_FOUND)
        end
      end
      describe 'if github id owner found, ' do
        it 'should return FOUND_BY_ID' do
          status = User.github_token_status('defgh', {id: 1}, nil)
          expect(status).to be(User::GithubBindingStatus::FOUND_BY_ID)
        end
      end
      describe 'if github email owner found, ' do
        it 'should return FOUND_BY_EMAIL' do
          status = User.github_token_status('zzxxxx', {id: 6, email: 'gith@ubuser.com'}, nil)
          expect(status).to be(User::GithubBindingStatus::FOUND_BY_EMAIL)
        end
      end
      describe 'if cannot find, ' do
        it 'registers a new user' do
          status = User.github_token_status('ss', {id:7, email: 'not@exist.com'}, nil)
          expect(status).to be(User::GithubBindingStatus::REGISTER_NEW_USER)
        end
      end
    end
    describe 'when current user is signed in, ' do
      describe 'when token owner is not found, ' do
        describe 'when id owner is not found, ' do
          describe 'when email owner is not found, ' do
            it "should return BINDING_FOR_CURRENT_USER" do
              status = User.github_token_status('abqqq', {} , @unbinded_github_user)
              expect(status).to be(User::GithubBindingStatus::BINDING_FOR_CURRENT_USER)
            end
          end
          describe 'when email owner is found, ' do
            it "when email owner is current user and current user did not bind github, should return BINDING_FOR_CURRENT_USER" do
              status = User.github_token_status('qqqqq', {email: 'gith@ubuser.com'}, @unbinded_github_user)
              expect(status).to be(User::GithubBindingStatus::BINDING_FOR_CURRENT_USER)
            end
            it "when email owner is current user and current user is binded github, should return TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN" do
              status =  User.github_token_status('qwpoui', {email: 'git@hubuser.cn'}, @github_user_2)
              expect(status).to be(User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN)
            end
            it "when email owner is not current user and email owner binded github, should return FOUND_BY_EMAIL_BUT_BINDED_GITHUB" do
              status =  User.github_token_status('qwpoui', {email: 'git@hubuser.cn'}, @github_user)
              expect(status).to be(User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_BINDED_GITHUB)
            end

            it "when email owner is not current user and email owner not bind github, should return FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB" do
              status =  User.github_token_status('qwpoui', {email: 'gith@ubuser.com'}, @github_user)
              expect(status).to be(User::GithubBindingStatus::FOUND_BY_EMAIL_BUT_NOT_BINDED_GITHUB)
            end
          end
        end
        describe 'when id owner is found, ' do
          it "if current user is id owner, returns TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN" do
            status = User.github_token_status('abtyu', {id: 1} , @github_user)
            expect(status).to be(User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER_SHOULD_UPDATE_TOKEN)
          end
          it "if current user is not id owner, returns FOUND_BY_ID_BUT_BINDED_GITHUB" do
            status = User.github_token_status('abtyu', {id: 1} , @github_user_2)
            expect(status).to be(User::GithubBindingStatus::FOUND_BY_ID_BUT_BINDED_GITHUB)
          end
        end
      end
      describe 'when token owner is found, ' do
        it "if current user is token owner, returns TOKEN_OWNER_IS_CURRENT_USER" do
          status = User.github_token_status('abcde', {} , @github_user)
          expect(status).to be(User::GithubBindingStatus::TOKEN_OWNER_IS_CURRENT_USER)
        end
        it "if current user is not token owner, returns CURRENT_USER_IS_NOT_TOKEN_OWNER" do
          status = User.github_token_status('abcde', {} , @github_user_2)
          expect(status).to be(User::GithubBindingStatus::CURRENT_USER_IS_NOT_TOKEN_OWNER)
        end
      end
    end
  end
end
