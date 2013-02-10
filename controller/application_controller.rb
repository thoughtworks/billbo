get '/' do
  @bills = Bill.all
	erb :bills
end
