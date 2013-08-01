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

When(/^I create a bill$/) do
  visit '/bill/new'

  fill_in 'issued_by', :with => 'XXX'
  fill_in 'due_date', :with => '2020/07/21'
  fill_in 'total_amount', :with => '100.00'
  fill_in 'barcode', :with => "000"
  
  image = FactoryGirl.build(:image)
  attach_file('image', image.path , visible: false)

  form = find_by_id 'new_bill'
  Capybara::RackTest::Form.new(page.driver, form.native).submit :name => nil
end

Given(/^I have created bills:$/) do |table|
  table.hashes.each do |row|
    visit '/bill/new'

    fill_in 'issued_by', :with => row["issued_by"]
    fill_in 'due_date', :with => row["due_date"]
    fill_in 'total_amount', :with => row["total_amount"]
    fill_in 'barcode', :with => row["barcode"]

    image = FactoryGirl.build(:image, filename: row["image"])
    attach_file('image', image.path, visible: false)

    form = find_by_id 'new_bill'
    Capybara::RackTest::Form.new(page.driver, form.native).submit :name => nil
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
