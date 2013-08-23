# encoding: UTF-8

require 'bundler/setup'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'carrierwave'
require 'carrierwave-google_drive'
require 'carrierwave/mongoid'
require 'pony'

require './functions'
require './config/initializers/carrierwave'

Bundler.require

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

# TODO Remove R18n
include R18n::Helpers
R18n.default_places = './i18n/'
R18n.set('pt')

I18n.load_path << File.join(Dir.pwd, "config", "locales", "en.yml")
I18n.load_path << File.join(Dir.pwd, "config", "locales", "pt.yml")

ENV['MONGO_TST_URI'] ||= 'mongodb://localhost/billbo_test'
Mongoid.load!('./config/mongoid.yml')

require './uploaders/file_uploader'

before do
  setup_locale
  setup_user
  setup_email

  if logged_in
    @admin = Admin.new
    @admin.email = session[:email]
  end
end

require './models/bill'
require './models/receipt'
require './models/admin'
require './models/auth'
require './models/reservation'
require './controllers/home_controller'
require './controllers/bill_controller'
require './controllers/admin_controller'
