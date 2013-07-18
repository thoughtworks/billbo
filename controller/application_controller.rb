before do
    session[:locale] = params[:lang] if params[:lang]
end

get '/' do
  @bills = Bill.where(status: :opened)
  erb :list_bills
end

get '/new_bill' do
  erb :new_bill
end

post '/new_bill' do
  bill = Bill.create(params)
  if bill
    redirect '/new_bill', :success => i18n.bill_creation_success
  else
    redirect '/new_bill', :error => i18n.bill_creation_fail
  end
end
