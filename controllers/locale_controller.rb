# encoding: UTF-8

get '/locale/:locale' do
  I18n.locale = params[:locale]
  session[:locale] = params[:locale]
  session[:i18n_hash] = locale_labels(session[:locale])

  redirect back
end
