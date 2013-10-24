# encoding: UTF-8

When(/^I (?:visit|open|access) the homepage$/) do
  visit "/"
end

Given(/^that there (?:is|are) (\d+) NGOs? subscribed with (\d+) bills?/) do |ngos,bills|
  ngos.to_i.times do
    FactoryGirl.create(:ngo_with_bills, bills_count: bills.to_i)
  end
end

Given(/^I am a contributor that is not logged in$/) do
end

Given(/^I am a contributor that is logged in$/) do
  log_in('mail@contributor.com')
end

Given(/^I (?:visit|open|access) a NGO's profile page$/) do
  visit "/"
  within first(".ngo-wrapper") do
    find("a.ngo-name").click
  end
end