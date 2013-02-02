require "bundler/setup"
require "sinatra"

configure do
	require "redis"
	redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
	uri = URI.parse(redisUri)
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get "/" do
	"Hello World!"
end