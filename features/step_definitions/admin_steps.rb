Given(/^I am an admin$/) do
	admin = FactoryGirl.create(:admin)
	log_in admin.email
end

Then(/^I should be able to access the bill creation page$/) do
  visit '/bill/new'
  expect(page).to have_content 'Nova Conta'
end


Given(/^I am not an admin$/) do
  log_in 'normal.user@example.com'
end

Then(/^I should not be able to access the bill creation page$/) do
  visit '/bill/new'
  expect(page).to_not have_content 'Nova Conta'
end

def log_in email
  if Capybara.current_driver == :webkit
    page.driver.browser.set_cookie("stub_email=#{email}; path=/; domain=127.0.0.1")
  else
    cookie_jar = Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
    cookie_jar[:stub_email] = email
  end
end
