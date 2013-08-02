get '/' do
  if logged_in
    @admin = Admin.new
    @admin.email = session[:email]
  end

  @bills = Bill.where(status: :opened)
  erb :list_bills
end

get '/bill/new' do
  erb :new_bill
end

post '/bill/create' do
  bill = Bill.create(params)

  if bill.save
    redirect '/bill/new', :success => i18n.bill_creation_ok
  else
    redirect '/bill/new', :error => i18n.bill_creation_fail
  end
end


get '/auth' do
  auth = Auth.new
  redirect auth.authorize_url(redirect_uri)
end

get '/oauth2callback' do
  auth = Auth.new(params[:code], redirect_uri)
  admin = Admin.new

  if admin.exists?(auth.email)
    session[:email] = auth.email
  else
    redirect '/', :error => i18n.not_an_admin_account
  end

  redirect '/'
end

get '/logout' do
  session.clear
  redirect '/'
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/oauth2callback'
  uri.query = nil
  uri.to_s
end