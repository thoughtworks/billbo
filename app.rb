# encoding: UTF-8

Bundler.require

require 'bundler/setup'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'carrierwave'
require 'carrierwave-google_drive'
require 'carrierwave/mongoid'
require 'pony'

require './uploaders/file_uploader'
require './functions'
require './config/initializers/carrierwave'
require './config/initializers/i18n'
require './config/initializers/mail'

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

ENV['MONGO_TST_URI'] ||= 'mongodb://localhost/billbo_test'
Mongoid.load!('./config/mongoid.yml')

before do
  setup_locale
  setup_user

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
