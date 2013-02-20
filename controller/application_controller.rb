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
    redirect '/new_bill', :success => "Bill created succesfully"
  else
    redirect '/new_bill', :error => "Problem creating the bill"
  end
end
