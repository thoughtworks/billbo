# encoding: UTF-8

When(/^I try to reserve an "(.*?)" bill$/) do |status|
  within "ul#all_bills" do
    @bill = first("div.#{status}-bill").find(:xpath, '../..')
    within @bill do
      find("a.btn-reserve").click
    end
  end
  find(:xpath, '//input[@name="email"]').set "contributor@example.com"
  click_button(I18n.t('reserve_bill'))
end

Then(/^that bill becomes "(.*?)"$/) do |status|
  within @bill do
    page.should have_css "div.#{status}-bill" #Didn't test due to a problem with the view
  end
end

Then(/^no other user can reserve it$/) do
  within @bill do
    page.should_not have_css "a.btn-reserve" #Didn't test due to a problem with the view
  end
end

When(/^I select an "(.*?)" bill$/) do |status|
  within "ul#all_bills" do
    @bill = first("div.#{status}-bill").find(:xpath, '../..')
  end
end

Then(/^I can't see the buttons that allow me to reserve bills$/) do
  page.should_not have_css "a.btn-reserve"
end