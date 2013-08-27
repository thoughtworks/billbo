# encoding: UTF-8

Given /^I select a bill$/ do
  @bill = Bill.first
end

When /^I upload a receipt$/ do
  visit "/bill/upload-receipt/#{@bill.id}"

  fill_in 'contributor_name', :with => 'user'
  fill_in 'contributor_email', :with => 'user@example.com'

  click_button 'Enviar recibo'
end

When /^I upload a receipt without the contributor email$/ do
  visit "/bill/upload-receipt/#{@bill.id}"

  fill_in 'contributor_name', :with => 'user'

  click_button 'Enviar recibo'
end
