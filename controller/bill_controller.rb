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
  @action = "/bill/upload-receipt/#{params[:bill_id]}"
  erb :upload_bill_receipt
end

post '/bill/upload-receipt/:bill_id' do
  bill = Bill.find(params[:bill_id])
  bill.contributor_email = params[:contributor_email]

  if bill.receipt_data_valid? && bill.update(params)
    redirect '/', :success => i18n.bill_creation_ok
  else
    redirect "/bill/upload-receipt/#{params[:bill_id]}", :error => i18n.bill_creation_fail
  end
end
