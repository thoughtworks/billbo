Given /^I have (\d+) bills$/ do |bills|
  bills.to_i.times do
    bill = FactoryGirl.build(:bill) 
    Bill.create(bill.to_hash)
  end
end

Given /^set the status of (\d+) them as (closed)$/ do |bills_quantity, status|
  bills_count = Bill.count
  raise IndexError, "There isn't #{bills_quantity.to_i} bills stored" if bills_quantity.to_i > bills_count

  bills = Bill.all
  (0...bills_quantity.to_i).each do |i|
    bills[i].close 
  end
end

When /^I open the home page$/ do
  visit '/'
end

Then /^it should list (\d+) bills$/ do |bills|
  bills_counter = if bills.eql?('all') 
                    Bill.count
                  else 
                    bills.to_i
                  end 

  within('#content') do
    page.should have_css("div.bill-container", count: bills_counter)
  end
end

When /^I create an empty bill$/ do
  Bill.create({})
end

Then /^it should succeed$/ do
  # intentionally blank = success
end
