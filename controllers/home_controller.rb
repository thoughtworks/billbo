# encoding: UTF-8

get '/' do
  if logged_as_admin?
    @bills = Bill.any_of({ status: :waiting_confirmation }, { status: :opened }, { status: :reserved}).asc(:status, :due_date)
    erb :"/bills/index"
  else
    @bills = Bill.any_of({ status: :opened }, { status: :reserved }).asc(:status, :due_date)
    erb :"/bills/index"
  end    
end
