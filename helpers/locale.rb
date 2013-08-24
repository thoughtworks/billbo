# encoding: UTF-8

helpers do
  def setup_locale
    I18n.locale = session[:locale] || :pt

    if params[:locale]
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end

    session[:i18n_hash] = locale_labels(session[:locale])
  end

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
