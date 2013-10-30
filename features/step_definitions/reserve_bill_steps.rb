# encoding: UTF-8

When(/^I try to reserve an "(.*?)" bill$/) do |status|
  within "ul#all_bills" do
    @bill_id = first("div.#{status}-bill").find(:xpath, '../..')["data-n"]
    bill = first(:xpath,"//li[@class='bill' and @data-n='#{@bill_id}']")
    within bill do
      find("a.btn-reserve").click
    end
  end
  find(:xpath, '//input[@name="email"]').set "contributor@example.com"
  click_button(I18n.t('reserve_bill'))
end

Then(/^that bill becomes "(.*?)"$/) do |status|
  bill = first(:xpath,"//li[@class='bill' and @data-n='#{@bill_id}']")
  within bill do
    page.should have_css "div.#{status}-bill"
  end
end

Then(/^no other user can reserve it$/) do
  bill = first(:xpath,"//li[@class='bill' and @data-n='#{@bill_id}']")
  within bill do
    page.should_not have_css "a.btn-reserve"
  end
end

Then(/^I can't see the buttons that allow me to reserve bills$/) do
  page.should_not have_css "a.btn-reserve"
end