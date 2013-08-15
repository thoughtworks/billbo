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

get '/bill/upload-receipt/:bill_id' do
  @action = "/bill/upload-receipt/#{params[:bill_id]}"
  erb :upload_bill_receipt
end

post '/bill/upload-receipt/:bill_id' do
  bill = Bill.find(params[:bill_id])
  receipt = bill.create_receipt(params)

  if bill.save
    send_email receipt, bill
    redirect '/', :success => i18n.upload_receipt_ok
  else
    redirect "/bill/upload-receipt/#{params[:bill_id]}", :error => i18n.upload_receipt_fail
  end
end

get '/bill/reserve/:bill_id' do
  @action = "/bill/reserve/#{params[:bill_id]}"
  erb :reserve_bill
end

post '/bill/reserve/:bill_id' do
  bill = Bill.find(params[:bill_id])
  bill.reservations.create(params)

  unless bill.reservations.last.errors.any?
    redirect '/', :success => i18n.reserve_bill_ok
  else
    redirect "/bill/reserve/#{params[:bill_id]}", :error => i18n.reserve_bill_fail
  end
end

private

def admin? email
  not Admin.all(email: email).empty?
end

def send_email payment, bill
  Admin.all.each do |admin|
    Pony.mail :to => admin.email,
          :from => payment.contributor_email,
          :subject => i18n.upload_receipt_subject,
          :html_body => erb(:email,
                            :locals => {:receipt => payment, :bill => bill },
                            :layout => false),
          :via => :smtp
    
  end
end