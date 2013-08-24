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

Dir.glob("./{config/initializers,controllers,models,helpers}/**/*.rb").each do |file|
  require file
end

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000, # In seconds
                             :secret => 'change_me'
end

before do
  setup_locale
  setup_user
end

# TODO This test-specific setup should not be here
def setup_user
  if ENV['RACK_ENV'] == 'test' && request.cookies["stub_email"]
    session[:email] = request.cookies["stub_email"]
  end
end

def h(content)
  Rack::Utils.escape_html(content)
end
