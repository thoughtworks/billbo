FactoryGirl.define do
  factory :bill do
    issued_by "company"
    due_date "25-01-2013"
    total_amount 123.45
    barcode "000000000000000000000000000000000000"
    status :opened
  end
end
