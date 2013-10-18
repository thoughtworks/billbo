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
  billboard = find("ul#all_bills")
  within billboard do
    pending # Falta conseguir uma maneira de analisar a ordem das datas de vencimento
  end
end