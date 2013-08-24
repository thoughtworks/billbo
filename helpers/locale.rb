# encoding: UTF-8

module Sinatra
  module LocaleHelper
    def locale_labels(locale_code)
      locale_file = "#{settings.root}/i18n/#{locale_code}.yml"

      unless File.exist?(locale_file)
        default_locale_file = "#{settings.root}/i18n/pt.yml"
        locale_file = default_locale_file
        R18n::I18n.default = "pt"
        session[:locale] = "pt"
      end

      YAML::load(File.read(locale_file)).to_json
    end
  end

  helpers LocaleHelper
end
