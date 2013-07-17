require 'bundler/setup'

Bundler.require
Mongoid.load!('./mongoid.yml', :development)

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

require './model/bill'
require './controller/application_controller'

require './db/seed.rb' if ENV['RACK_ENV'] == "development"
