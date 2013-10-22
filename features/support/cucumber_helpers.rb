# encoding: UTF-8

def create_bill(attributes = {})
  attributes = attributes.reverse_merge(
    issued_by: "XXX",
    due_date: "01/01/2020",
    total_amount: 100.00,
    image: FactoryGirl.build(:image))

  visit '/bill/new'

  fill_in 'issued_by', :with => attributes[:issued_by]
  fill_in 'due_date', :with => attributes[:due_date]
  fill_in 'total_amount', :with => attributes[:total_amount]

  image = attributes[:image]
  attach_file('image', image.path , visible: false)

  click_button "Criar Conta"
end

def log_in(email)
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return(email)
end

def code_of(language)
  languageCodes = { "portuguese" => "pt", "english" => "en" }
  languageCodes[language.downcase]
end