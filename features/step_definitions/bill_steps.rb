# encoding: UTF-8

Given /^I have (\d+) bills$/ do |n|
  n.to_i.times do
    FactoryGirl.create(:bill)
  end
end

Given /^I set the status of (\d+) of them as (paid)$/ do |n, status|
  n.to_i.times {
    Bill.where(status: :opened).update(status: status)
  }
end

Given /^there is a bill with barcode "(.*?)"$/ do |barcode|
  FactoryGirl.create(:bill, barcode: barcode)
end

When /^I try to create a new bill with barcode "(.*?)"$/ do |barcode|
  create_bill(barcode: barcode)
end

When(/^I create a bill$/) do
  create_bill
end

Given(/^I have created bills:$/) do |table|
  table.hashes.each do |row|
    create_bill(issued_by: row[:issued_by],
                due_date: row[:due_date],
                total_amount: row[:total_amount],
                barcode: row[:barcode],
                image: FactoryGirl.build(:image, filename: row["image"]))
  end
end

When(/^I should view bills information:$/) do |table|
  table.hashes.each do |row|
    within('#all-bills') do
      page.should have_xpath("//img[@src=\"/uploads/#{row['image']}\"]")
      page.should have_xpath("//img[@alt=\"#{row['image']}\"]")
      page.should have_content(row["issued_by"])
      page.should have_content(row["total_amount"])
    end
  end
end

When /^I open the home page$/ do
  visit '/'
end

Then /^it should list (\d+) bills$/ do |n|
  bills_count = n=='all' ? Bill.count : n.to_i

  within('#all-bills') do
    page.should have_css("li.bill-container", count: bills_count)
  end
end

Then(/^it should show success message$/) do
  page.should have_css 'div.alert-box.success'
end

When /^I try to create an empty bill$/ do
  Bill.create({})
end

Then /^it should fail$/ do
  Bill.count.should == 0
end

Then /^I should see the error message "(.*?)"$/ do |message|
  page.should have_content(message)
end
