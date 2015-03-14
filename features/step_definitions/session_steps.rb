When /^I sign in$/ do
  visit new_user_session_url
  fill_in 'user_name', with: @me.name
  fill_in 'user_password', with: @me.password
  click_button I18n.t('action.sign_in')
end

Then /^I should sign in successfully$/ do
  expect(page).to have_content @me.nick
end

And /^I click the "Sign Out" button in the header$/ do
  click_link I18n.t('action.sign_out')
end

Then /^I should sign out successfully$/ do
  expect(page).not_to have_content @me.nick
end