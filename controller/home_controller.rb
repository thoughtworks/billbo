get '/' do
  @bills = Bill.where(status: :opened)
  erb :list_bills
end
