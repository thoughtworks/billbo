before do
  session[:locale] = params[:locale] if params[:locale]
  session[:locale] = 'pt' unless session[:locale]
end

get '/' do
  @bills = Bill.where(status: :opened)
  erb :list_bills
end

get '/bill/new' do
  erb :new_bill
end

post '/bill/create' do
  bill = Bill.create(params)
  if bill
    redirect '/bill/new', :success => i18n.bill_creation_success
  else
    redirect '/bill/new', :error => i18n.bill_creation_fail
  end
end
