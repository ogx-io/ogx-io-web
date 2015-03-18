When /^I sign in manually as "(.*?)" with password "(.*?)"$/ do |name, password|
  visit new_user_session_path
  fill_in 'user_name', with: name
  fill_in 'user_password', with: password
  click_button I18n.t('action.sign_in')
end

Then /^I would sign in$/ do
  expect(page).to have_content @me.nick
end

And /^I click the "Sign Out" button in the header$/ do
  click_link I18n.t('action.sign_out')
end

Then /^I would sign out$/ do
  expect(page).not_to have_content @me.nick
end

Then /^I would not sign in/ do
  expect(page).not_to have_content @me.nick
end

Given /^I have already signed in as "(.*?)" with password "(.*?)"$/ do |name, password|
  step %(I am a user with username "#{name}" and password "#{password}")
  step %(I sign in manually as "#{name}" with password "#{password}")
  step %(I would sign in)
end