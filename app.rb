require 'bundler/setup'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

Bundler.require
require './model/bill'

Mongoid.load!('./mongoid.yml', :development)

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

require './db/seed.rb' if ENV['RACK_ENV'] == "development"
require './controller/application_controller.rb'
