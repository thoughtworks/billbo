get '/' do
  redirect to('/pt')
end

get '/:locale' do
  @bills = Bill.all
	erb :list_bills
end
