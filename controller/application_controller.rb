before do
  session[:locale] ||= 'pt_BR'
  session[:i18n_hash] ||= localeLabels(session[:locale])

  if params[:locale]
    session[:locale] = params[:locale]
    session[:i18n_hash] = localeLabels(session[:locale])
  end
end

def localeLabels localeCode
  current_dir = File.expand_path File.dirname(__FILE__);
  YAML::load(File.read("#{current_dir}/../i18n/#{localeCode}.yml")).to_json
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
  if bill.save
    redirect '/bill/new', :success => i18n.bill_creation_ok
  else
    redirect '/bill/new', :error => i18n.bill_creation_fail
  end
end
