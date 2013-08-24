# encoding: UTF-8

set :available_locales, [:en, :pt]

Dir.glob("#{settings.root}/config/locales/**/*.yml").each do |file|
  I18n.load_path << file
end

I18n.default_locale = :pt
