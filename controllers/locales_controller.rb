# encoding: UTF-8

get '/locale/:locale' do
  I18n.locale = params[:locale]
  session[:i18n_hash] = locale_labels(params[:locale])

  redirect back
end
