# encoding: UTF-8

require 'factory_girl'

files_path = (File.join( settings.root, "spec", "fixtures"))

FactoryGirl.define do
  sequence(:issued_by)    { "Company #{('A'..'Z').to_a.sample}" }
  sequence(:due_date)     { time_rand(Date.today.to_time, (Date.today+90).to_time) }
  sequence(:total_amount) { "%.2f" % Random.rand(1.0..100.0) }
  sequence(:url)          { "image#{(1..99).to_a.sample}" }
  sequence(:filename)     { "filename#{(1..99).to_a.sample}"}

  factory :bill do
    issued_by     { generate(:issued_by) }
    due_date      { generate(:due_date) }
    total_amount  { generate(:total_amount) }
    url           { generate(:url) }
    filename      { generate(:filename) }
    ngo
  end

  factory :ngo do
    sequence(:name) { "NGO #{('A'..'Z').to_a.sample}" }
    description { "Mussum ipsum cacilds, vidis litro abertis. Consetis adipiscings elitis. Pra lá , depois divoltis porris, paradis. Paisis, filhis, espiritis santis. Mé faiz elementum girarzis, nisi eros vermeio, in elementis mé pra quem é amistosis quis leo. Manduma pindureta quium dia nois paga. Sapien in monti palavris qui num significa nadis i pareci latim. Interessantiss quisso pudia ce receita de bolis, mais bolis eu num gostis." }
    phone { "+55 (81) 3034-5626"}
    website { "my.com.br" }
    email { "my@gmail.com" }
    contact { "Mary Lee" }
    photo_url {"https://docs.google.com/uc?&id=0Bya4RyzHQ9KxbUxPaGpkXzFMWG8"}

    ignore do
      bills_count 1
    end

    factory :ngo_with_bills do
      after(:create) do |ngo, evaluator|
        FactoryGirl.create_list(:bill, evaluator.bills_count, ngo: ngo)
      end
    end
  end

  factory :reservation do
    phone_number {"(81) 8855-5522"}
    email {"john@gmail.com"}
  end

  factory :bill_file, class: File do
    filename        { "bill.pdf" }
    filepath        { files_path }
    initialize_with { new(File.join(filepath, filename)) }
  end

  factory :not_pdf_file, class: File do
    filename        { "bill.png" }
    filepath        { files_path }
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
