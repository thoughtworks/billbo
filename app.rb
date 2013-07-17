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

  require 'redis'
	redisUri = ENV['REDISCLOUD_URL'] || 'redis://localhost:6379'
	uri = URI.parse(redisUri)
	REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

require './db/seed.rb' if ENV['RACK_ENV'] == "development"
require './controller/application_controller.rb'
