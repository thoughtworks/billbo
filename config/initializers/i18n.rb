# encoding: UTF-8

set :available_locales, [:en, :pt]
set :locales_path, "#{settings.root}/config/locales"

Dir.glob("#{settings.locales_path}/**/*.yml").each do |file|
  I18n.load_path << file
end

I18n.default_locale = :pt
