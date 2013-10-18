# encoding: UTF-8

When(/^I (?:visit|open|access) the homepage$/) do
  visit "/"
end

Given(/^that there (?:is|are) (\d+) NGOs? subscribed with (\d+) bills? on each one$/) do |ngos,bills|
  ngos.to_i.times do
    FactoryGirl.create(:ngo_with_bills, bills_count: bills.to_i)
  end
end

Given(/^I am a contributor$/) do
  
end

Given(/^I (?:visit|open|access) a NGO's profile page$/) do
  within first(".ngo-wrapper") do
    find("a.ngo-name").click
  end
end