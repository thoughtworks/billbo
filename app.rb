require 'bundler/setup'
Bundler.require
require './model/bill'

configure do
	require 'redis'
	redisUri = ENV['REDISCLOUD_URL'] || 'redis://localhost:6379'
	uri = URI.parse(redisUri)
	REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

require './controller/application_controller.rb'
