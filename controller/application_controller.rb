get '/' do
  @bills = Bill.all
	erb :list_bills
end

get '/new_bill' do
  erb :new_bill
end

post '/new_bill' do
  Bill.create(params)
  redirect to ('/new_bill')
end
