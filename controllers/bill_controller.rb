get '/bill/new' do
  if session[:email].nil?
  	redirect '/auth?url=/bill/new'
  end
  
  if admin? session[:email]
    erb :new_bill
  else
    redirect '/', :error => i18n.not_an_admin_account
  end
end

post '/bill/create' do
  bill = Bill.create(params)

  if bill.save
    redirect '/bill/new', :success => i18n.bill_creation_ok
  else
    redirect '/bill/new', :error => i18n.bill_creation_fail
  end
end

def admin? email
  admin = Admin.new
  admin.exists? email
end

get '/bill/upload-receipt/:bill_id' do
  @action = "/bill/upload-receipt/#{params[:bill_id]}"
  erb :upload_bill_receipt
end

post '/bill/upload-receipt/:bill_id' do
  bill = Bill.find(params[:bill_id])
  bill.create_receipt(params)

  if bill.save
    redirect '/', :success => i18n.upload_receipt_ok
  else
    redirect "/bill/upload-receipt/#{params[:bill_id]}", :error => i18n.upload_receipt_fail
  end
end
