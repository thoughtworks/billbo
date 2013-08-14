require 'factory_girl'

image_path= (File.join( settings.root, "spec", "fixtures"))

FactoryGirl.define do
  sequence(:issued_by)    { "Company #{('A'..'Z').to_a.sample}" }
  sequence(:due_date)     { time_rand(Date.today.to_time, (Date.today+90).to_time) }
  sequence(:total_amount) { "%.2f" % Random.rand(1.0..100.0) }
  sequence(:barcode)      { (0...36).map{ ('0'..'9').to_a[rand(10)] }.join }
  sequence(:url)          { "image#{(1..99).to_a.sample}" }
  sequence(:filename)     { "filename#{(1..99).to_a.sample}"}

  factory :bill do
    issued_by     { generate(:issued_by) }
    due_date      { generate(:due_date) }
    total_amount  { generate(:total_amount) }
    barcode       { generate(:barcode) }
    url           { generate(:url) }
    filename      { generate(:filename) }
  end
  factory :image, class: File do
    filename        { "bill.png" }
    filepath        { image_path }
    initialize_with { new(File.join(filepath, filename)) }
  end
  factory :admin do
    email         { "admin@example.com" }
  end
  factory :receipt do
    contributor_name "John"
    contributor_email "john@gmail.com"
    url { generate :url }
    filename { generate :filename }
  end
end

def time_rand(from=0.0, to=Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end
