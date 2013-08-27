# encoding: UTF-8

Given /^I select a bill$/ do
  @bill = Bill.all.first
end

When /^I upload a receipt$/ do
  visit "/bill/upload-receipt/#{@bill.id}"

  fill_in 'contributor_name', :with => 'user'
  fill_in 'contributor_email', :with => 'user@example.com'
  
  form = find_by_id 'upload_receipt'
  Capybara::RackTest::Form.new(page.driver, form.native).submit :name => nil
end
