# encoding: UTF-8

module Sinatra
  module LocaleHelper
    # FIXME We are loading the locales in a session just to use it
    # in the javascript validation.
    def locale_labels
      locale_code = session[:locale]
      locale_file = "#{settings.locales_path}/#{locale_code}.yml"
      YAML::load(File.read(locale_file))[locale_code.to_s].to_json
    end

    def set_locale(locale)
      session[:locale] = locale || I18n.default_locale
      I18n.locale = locale
    end
  end

  helpers LocaleHelper
end
