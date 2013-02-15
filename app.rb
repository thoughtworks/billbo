require 'bundler/setup'
require 'sinatra'
Bundler.require
require './model/bill'
require './model/file_uploader'

configure do
	require 'redis'
	redisUri = ENV['REDISCLOUD_URL'] || 'redis://localhost:6379'
	uri = URI.parse(redisUri)
	REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

require './db/seed.rb' if ENV['RACK_ENV'] == "development"
require './controller/application_controller.rb'
