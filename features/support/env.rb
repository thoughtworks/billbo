# encoding: UTF-8

ENV['RACK_ENV'] ||= 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app')
require 'cucumber/rspec/doubles'
require 'capybara'
require 'capybara/cucumber'
require 'factory_girl'
require './spec/factories'
require 'rspec'

Capybara.app = eval("Rack::Builder.new {( " + File.read(File.join(settings.root, 'config.ru')) + "\n )}")

class SomeWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

After do
  Mongoid.purge!
  FileUtils.rm_rf(Dir[File.join(File.dirname(__FILE__), "../../public/#{FileUploader.store_dir}/[^.]*")])
end

World do
  SomeWorld.new
end

CarrierWave::Uploader::GoogleDrive.configure do |config|
  config.storage = :file
  config.enable_processing = false
end
