When /^I create an empty bill$/ do
    Bill.create({})
end

Then /^it should succeed$/ do
    # intentionally blank = success
end
