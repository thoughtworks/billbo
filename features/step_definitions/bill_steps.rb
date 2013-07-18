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

When /^I open the home page$/ do
  visit '/'
end

Then /^it should list (\d+) bills$/ do |n|
  bills_count = n=='all' ? Bill.count : n.to_i

  within('#all-bills') do
    page.should have_css("li.bill-container", count: bills_count)
  end
end

When /^I try to create an empty bill$/ do
  Bill.create({})
end

Then /^it should fail$/ do
  Bill.count.should == 0
end
