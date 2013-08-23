include R18n::Helpers

# TODO Remove R18n
R18n.default_places = './i18n/'
R18n.set('pt')

I18n.load_path << File.join(Dir.pwd, "config", "locales", "en.yml")
I18n.load_path << File.join(Dir.pwd, "config", "locales", "pt.yml")
