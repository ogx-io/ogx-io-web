And(/^I have binded a github account$/) do
  @me.update(github_id: '123456', github_user_name: 'cuterxy', github_access_token: '123456789')
end

And(/^I click the unbind github account link$/) do
  visit edit_accounts_user_path(@me)
  click_link 'unbind-github-account'
end

Then(/^I should unbind my github account$/) do
  @me.reload
  expect(@me.github_id).to eq('')
  expect(@me.github_user_name).to eq('')
  expect(@me.github_access_token).to eq('')
end