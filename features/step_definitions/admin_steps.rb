# encoding: UTF-8

Given(/^I am an admin$/) do
	admin = FactoryGirl.create(:admin)
	log_in(admin.email)
end

Then(/^I should be able to access the bill creation page$/) do
  visit '/bill/new'
  expect(page).to have_content 'Nova Conta'
end


Given(/^I am not an admin$/) do
  log_in('normal.user@example.com')
end

Then(/^I should not be able to access the bill creation page$/) do
  visit '/bill/new'
  expect(page).to_not have_content 'Nova Conta'
end

def log_in(email)
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return(email)
end
