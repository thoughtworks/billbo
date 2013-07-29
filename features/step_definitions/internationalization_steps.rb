def code_of language 
  languageCodes = { "portuguese" => "pt", "english" => "en" }
  languageCodes[language.downcase]
end

Given(/^the website is in (.*)$/) do |language|
  visit "/"
  click_link "link-#{code_of(language)}"
end

When(/^I change the website language to (.*)$/) do |language|
  click_link "link-#{code_of(language)}"
end

Then(/^the website should be in (.*)$/) do |language|
  page.should have_css("html[lang=\"#{code_of(language)}\"]")
end
