# encoding: UTF-8

Then(/^I must see a name, a description, a phone number and a website link of that NGO$/) do
  contacts = find("div.contact-info")
  within contacts do
    find("#contact").text.should_not == ''
    find("#phone").text.should_not == ''
    find("#website").text.should_not == ''
    find("#email").text.should_not == ''
  end
end

Then(/^I must see their billboard with their bills sorted, by default, by due date$/) do
  within("section.sort_list") do
    active = find("li.active")
    within active do
      find("a").text.should == I18n.t('due_date')
    end
  end
  dueDates = []
  billboard = find("ul#all_bills")
  within billboard do
    page.all("li.bill").each do |bill|
      within bill do
        dueDates.push find("span.due_date")["data-timestamp"]
      end
    end
    dueDates.should == dueDates.sort
  end
end