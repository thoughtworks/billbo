get '/' do
  redirect to('/pt')
end

get '/:locale' do
  @bills = Bill.all
	erb :list_bills
end

get '/:locale/new_bill' do
  erb :new_bill
end
