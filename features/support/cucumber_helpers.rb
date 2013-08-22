def create_bill(attributes = {})
  attributes = attributes.reverse_merge(
    issued_by: "XXX",
    due_date: "01/01/2020",
    total_amount: 100.00,
    barcode: "0123",
    image: FactoryGirl.build(:image)
  )


  visit '/bill/new'

  fill_in 'issued_by', :with => attributes[:issued_by]
  fill_in 'due_date', :with => attributes[:due_date]
  fill_in 'total_amount', :with => attributes[:total_amount]
  fill_in 'barcode', :with => attributes[:barcode]

  image = attributes[:image]
  attach_file('image', image.path , visible: false)

  click_button "Criar Conta"
end
