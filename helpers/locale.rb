# encoding: UTF-8

module Sinatra
  module LocaleHelper
    # FIXME Check why we need this
    def locale_labels(locale_code)
      locale_file = "#{settings.root}/config/locales/#{locale_code}.yml"

      unless File.exist?(locale_file)
        default_locale_file = "#{settings.root}/config/locales/pt.yml"
        locale_file = default_locale_file
        I18n.locale = :pt
      end

      YAML::load(File.read(locale_file)).to_json
    end
  end

  helpers LocaleHelper
end
