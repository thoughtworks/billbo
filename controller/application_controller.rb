before do
  params[:locale] = "pt"
end

get '/' do
  @bills = Bill.all
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
