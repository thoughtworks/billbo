def test_env?
  ENV['RACK_ENV'] == 'test'
end

def setup_carrierwave
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    if test_env?
      config.storage = :file
      config.enable_processing = false
    else
      config.storage = :google_drive
    end
  end
end

def setup_locale
  session[:locale] = params[:locale] if params[:locale]
  session[:i18n_hash] = locale_labels(session[:locale])
end

def locale_labels locale_code
  current_dir = File.expand_path File.dirname(__FILE__);
  locale_file = "#{current_dir}/i18n/#{locale_code}.yml"

  unless File.exist? locale_file
    default_locale_file = "#{current_dir}/i18n/pt.yml"
    locale_file = default_locale_file
    R18n::I18n.default = 'pt'
    session[:locale] = 'pt'
  end

  YAML::load(File.read(locale_file)).to_json
end

def logged_in
  not session[:email].nil?
end