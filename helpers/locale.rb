# encoding: UTF-8

module Sinatra
  module LocaleHelper
    # FIXME Workaround while we still have lots of calls to `i18n`
    def i18n
      Class.new do
        def method_missing(name, *args, &block)
          I18n.t(name.to_sym)
        end
      end.new
    end

    # FIXME Check why we need this
    def locale_labels(locale_code)
      locale_file = "#{settings.root}/config/locales/#{locale_code}.yml"

      unless File.exist?(locale_file)
        default_locale_file = "#{settings.root}/i18n/pt.yml"
        locale_file = default_locale_file
        I18n.locale = :pt
        session[:locale] = :pt
      end

      YAML::load(File.read(locale_file)).to_json
    end
  end

  helpers LocaleHelper
end
