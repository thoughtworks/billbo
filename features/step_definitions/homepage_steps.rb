# encoding: UTF-8

Then(/^I must see the NGOs' links with name, photo and philosophy of each NGO$/) do
  page.all(".ngo-wrapper").each do |element|
    within element do
      find("h4.title").text.should_not == ''
      find("p.description").text.should_not == ''
      find("img").should be_visible
    end
  end
end

When(/^I click on a link of the NGO$/) do
  within first(".ngo-wrapper") do
    link = find("a.ngo-name")
    @href = link['href']
    link.click
  end
end

Then(/^I must be redirected to the NGO's profile$/) do
  page.current_path.should == @href
end