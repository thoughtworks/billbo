get '/' do
  @bills = Bill.where(status: :opened)
  @bills = @bills.sort_by {|obj| obj.due_date }
  erb :list_bills
end