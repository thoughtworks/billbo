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