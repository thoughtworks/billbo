# encoding: UTF-8

def test_env?
  ENV['RACK_ENV'] == 'test'
end

def setup_carrierwave
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    config.storage = :google_drive
  end
end

def setup_locale
  I18n.locale = session[:locale] || :pt

  if params[:locale]
    session[:locale] = params[:locale]
    I18n.locale = params[:locale]
  end

  session[:i18n_hash] = locale_labels(session[:locale])
end

def setup_user
  if test_env?
    session[:email] = request.cookies["stub_email"] if request.cookies["stub_email"]
  end
end

def locale_labels(locale_code)
  current_dir = File.expand_path File.dirname(__FILE__);
  locale_file = "#{current_dir}/i18n/#{locale_code}.yml"

  unless File.exist? locale_file
    default_locale_file = "#{current_dir}/i18n/pt.yml"
    locale_file = default_locale_file
    R18n::I18n.default = "pt"
    session[:locale] = "pt"
  end

  YAML::load(File.read(locale_file)).to_json
end

def logged_in
  not session[:email].nil?
end

def logged_as_admin?
  logged_in and not Admin.all(email: session[:email]).empty?
end

def setup_email
  if !test_env?
    Pony.options = { :via => :smtp,
                     :via_options => {
                        :address              => 'smtp.gmail.com',
                        :port                 => '587',
                        :enable_starttls_auto => true,
                        :user_name            => ENV['billbo_login'],
                        :password             => ENV['billbo_password'],
                        :authentication       => :plain,
                        :domain               => "localhost.localdomain"
                      }
                    }
  end
end

def h(text)
  Rack::Utils.escape_html text
end
