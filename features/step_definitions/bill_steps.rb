Given /^I have (\d+) bills created$/ do |bills|
  bills.to_i.times do
    bill = FactoryGirl.build(:bill) 
    Bill.create(bill.to_hash)
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
