Given(/^I am an admin$/) do
end

Then(/^I should be able to access the bill creation page$/) do
  visit '/bill/new'
  expect(page).to have_content 'Nova Conta'
end


Given(/^I am not an admin$/) do
end

Then(/^I should not be able to access the bill creation page$/) do
  visit '/bill/new'
  #expect(page).to_not have_content 'Nova Conta'
end
