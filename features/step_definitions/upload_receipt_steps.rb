# encoding: UTF-8

Given /^I select a bill$/ do
  @bill = Bill.first
end

When /^I upload a receipt$/ do
  visit "/bills/#{@bill.id}/receipts/new"

  fill_in 'contributor_name', :with => 'user'
  fill_in 'contributor_email', :with => 'user@example.com'

  click_button 'Enviar recibo'
end

When /^I upload a receipt with not supported format$/ do
  visit "/bills/#{@bill.id}/receipts/new"

  fill_in 'contributor_name', :with => 'user'
  fill_in 'contributor_email', :with => 'user@example.com'
  image_not_supported = FactoryGirl.build(:image, filename: "example.pepper")
  attach_file('image', image_not_supported.path , visible: false)

  click_button 'Enviar recibo'
end

When /^I upload a receipt without the contributor email$/ do
  visit "/bills/#{@bill.id}/receipts/new"

  fill_in 'contributor_name', :with => 'user'

  click_button 'Enviar recibo'
end