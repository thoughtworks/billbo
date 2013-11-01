# encoding: UTF-8

Then(/^I can't see the buttons that allow me to upload receipts$/) do
  page.should_not have_css "a.btn-upload"
end