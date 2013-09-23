# encoding: UTF-8

get '/bill/new' do
  if !logged_in
    redirect '/auth?url=/bill/new'
  end

  if logged_as_admin?
    erb :"/bills/new", locals: { errors: [] }
  else
    redirect '/', :error => I18n.t(:not_an_admin_account)
  end
end

post '/bill/create' do
  due_date = Date.parse(params[:due_date]) rescue nil
  bill = Bill.new(params.merge("due_date" => due_date))

  if bill.save
    redirect '/bill/new', :success => I18n.t(:bill_creation_ok)
  else
    erb :"/bills/new", locals: { errors: bill.errors.full_messages }
  end
end

get '/bill/reserve/:bill_id' do
  @action = "/bill/reserve/#{params[:bill_id]}"
  erb :"bills/reserve"
end

post '/bill/reserve/:bill_id' do
  bill = Bill.find(params[:bill_id])
  bill.reservations.create(params)

  unless bill.reservations.last.errors.any?
    bill.status = :reserved
    bill.save
    redirect '/', :success => I18n.t(:reserve_bill_ok)
  else
    redirect "/bill/reserve/#{params[:bill_id]}", :error => I18n.t(:reserve_bill_fail)
  end
end

post '/delete/:bill_id' do
  if logged_as_admin?
    begin
      bill = Bill.find(params[:bill_id])
      bill.delete
    rescue Mongoid::Errors::DocumentNotFound => e
    end
    redirect '/', :success => I18n.t(:bill_delete_ok)
  else
    redirect '/', :error => I18n.t(:not_an_admin_account)
  end

end