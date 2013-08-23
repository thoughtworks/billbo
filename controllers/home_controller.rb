# encoding: UTF-8

get '/' do
  @bills = Bill.any_of({ status: :opened }, { status: :reserved }).asc(:status, :due_date)
  erb :list_bills
end
