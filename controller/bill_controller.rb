get '/bill/new' do
  erb :new_bill
end

post '/bill/create' do
  bill = Bill.create(params)

  if bill.save
    redirect '/bill/new', :success => i18n.bill_creation_ok
  else
    redirect '/bill/new', :error => i18n.bill_creation_fail
  end
end

get '/bill/upload-receipt/:bill_id' do
  erb :upload_bill_receipt
end

post '/bill/upload-receipt/:bill_id' do
  @bill_id = params[:bill_id]
  erb :upload_bill_receipt
end