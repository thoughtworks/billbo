FactoryGirl.define do
  factory :bill do
    sequence (:id) 
    issued_by "company"
    due_date "25-01-2013"
    total_amount 123.45
    barcode "000000000000000000000000000000000000"
    receipt nil
    status :opened
    initialize_with { new(id, issued_by, due_date, total_amount, barcode, receipt, status) }
  end
end
