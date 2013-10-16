# encoding: UTF-8

get '/locale/:locale' do
  locale = params[:locale].to_sym
  locale = settings.available_locales.include?(locale) ? locale : I18n.default_locale

  set_locale(locale)

  redirect back
end
