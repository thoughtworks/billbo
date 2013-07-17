require 'factory_girl'

FactoryGirl.define do
  sequence(:issued_by)    { "Company #{('A'..'Z').to_a.sample}" }
  sequence(:due_date)     { time_rand Time.local(2013, 1, 1), Time.now }
  sequence(:total_amount) { "%.2f" % Random.rand(1.0..100.0) }

  factory :bill do
    issued_by     { generate(:issued_by) }
    due_date      { generate(:due_date) }
    total_amount  { generate(:total_amount) }
    barcode       '000000000000000000000000000000000000'
    status        { :open }
  end
end

def time_rand(from=0.0, to=Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end
