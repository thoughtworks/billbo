get '/' do
  @bills = Bill.all
	erb :index
end
