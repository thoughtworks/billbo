# encoding: UTF-8

authentication_required_for '/bill/reserve/:bill_id', :post

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

post '/bill/new' do
  bill = Bill.new(params)
  if bill.save
    redirect '/bill/new', :success => I18n.t(:bill_creation_ok)
  else
    erb :"/bills/new", locals: { errors: bill.errors.full_messages }
  end
end

get '/bill/reserve/:bill_id' do
  @action = "/bill/reserve/#{params[:bill_id]}"
  bill = Bill.find(params[:bill_id])
  @ngo = bill.ngo
  erb :"bills/reserve"
end

post '/bill/reserve/:bill_id' do
  bill = Bill.find(params[:bill_id])
  ngo = bill.ngo

  if bill.reserve(params)
    redirect "/ngo/#{ngo.id}", :success => I18n.t(:reserve_bill_ok)
  else
    redirect "/bill/reserve/#{params[:bill_id]}", :error => bill.errors.full_messages
  end
end

delete '/bill/remove/:bill_id' do
  if logged_as_admin?
    begin
      bill = Bill.find(params[:bill_id])
      bill.delete
    rescue Mongoid::Errors::DocumentNotFound => e
    end
    redirect '/', :success => I18n.t(:bill_remove_ok)
  else
    redirect '/', :error => I18n.t(:not_an_admin_account)
  end
end

get '/bill/update/:bill_id' do
  if !logged_in
    redirect '/auth?url=/bill/new'
  end

  if logged_as_admin?
    @action = "/bill/update/#{params[:bill_id]}"
    @bill = Bill.find(params[:bill_id])

    erb :"bills/update"
  else
    redirect '/', :error => I18n.t(:not_an_admin_account)
  end
end

post '/bill/update/:bill_id' do
  due_date = nil

  begin
    @bill = Bill.find(params[:bill_id])
    due_date = Date.parse(params[:due_date])

    if @bill.update_attributes(params.merge("due_date" => due_date))
      redirect "/bill/update/#{params[:bill_id]}", :success => I18n.t(:update_bill_ok)
    else
      erb :"/bills/update", locals: { errors: @bill.errors.full_messages }
    end
  rescue
    erb :"/bills/update", locals: { errors: [I18n.t(:invalid_due_date)] }
  end
end

get '/bill/close/:bill_id' do
  @bill = Bill.find(params[:bill_id])
  if @bill.status != :waiting_confirmation
    redirect '/', :error => I18n.t("bill_not_able_to_close")
  elsif !logged_as_admin?
    redirect '/', :error => I18n.t("not_an_admin_account")
  else
    @bill.status = :closed
    @bill.save!
    redirect '/', :success => I18n.t("bill_closed_ok")
  end
end