require './app'
set :root, File.dirname(__FILE__)
run Sinatra::Application
set :encoding, "utf-8"
