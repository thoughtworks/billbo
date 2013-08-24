# encoding: UTF-8

include R18n::Helpers

# TODO Remove R18n
R18n.default_places = './i18n/'
R18n.set('pt')

Dir.glob("#{settings.root}/config/locales/**/*.yml").each do |file|
  I18n.load_path << file
end
