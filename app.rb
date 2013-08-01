require 'bundler/setup'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'carrierwave'
require 'carrierwave-google_drive'
require 'carrierwave/mongoid'

Bundler.require

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

R18n::I18n.default = 'pt'

ENV['MONGO_TST_URI'] ||= 'mongodb://localhost/billbo_test'
Mongoid.load!('./config/mongoid.yml')

if ENV['RACK_ENV'] == 'test'
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    config.storage = :google_drive
  end
end

require './uploaders/file_uploader'
require './model/bill'
require './controller/application_controller'

