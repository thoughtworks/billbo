# encoding: UTF-8

module Sinatra
  module LocaleHelper
    # FIXME Check why we need this
    def locale_labels(locale_code)
      locale_file = "#{settings.root}/config/locales/#{locale_code}.yml"
      YAML::load(File.read(locale_file))[locale_code.to_s].to_json
    end
  end

  helpers LocaleHelper
end
