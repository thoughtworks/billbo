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