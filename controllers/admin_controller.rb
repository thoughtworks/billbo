get '/auth' do
  auth = Auth.new
  url = params["url"] || '/'
  redirect auth.authorize_url redirect_uri "url=#{url}"
end

get '/oauth2callback' do
  auth = Auth.new(params[:code], redirect_uri("url=#{params["url"]}"))
  session[:name] = auth.name
  session[:email] = auth.email
  redirect params["url"]
end

get '/logout' do
  session.clear
  redirect '/'
end

def redirect_uri query = nil
  uri = URI.parse(request.url)
  uri.path = '/oauth2callback'
  uri.query = query
  uri.to_s
end
