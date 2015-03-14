Given(/^I am a user with username "(.*?)" and password "(.*?)"$/) do |name, password|
  @me = create(:user, name: name, password: password)
end

