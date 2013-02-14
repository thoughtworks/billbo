get '/' do
  @bills = Bill.all
	erb :list_bills
end
