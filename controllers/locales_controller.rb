# encoding: UTF-8

get '/locale/:locale' do
  locale = params[:locale].to_sym
  locale = settings.available_locales.include?(locale) ? locale : I18n.default_locale

  session[:locale] = locale
  I18n.locale = locale
  locale_labels(locale)

  redirect back
end
