# encoding: UTF-8

ENV['RACK_ENV'] ||= 'test'

require './app'
require 'capybara'
require 'pony'

require 'factory_girl'
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.color = true
  config.formatter = :documentation

  config.before(:each) do
    Mongoid.purge!
    Pony.stub(:deliver)
    setup_carrierwave
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir[File.join(File.dirname(__FILE__), "../public/#{FileUploader.store_dir}/[^.]*")])
  end
end

def setup_carrierwave
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

def homepage_url
  'http://example.org/'
end

def share_url
  'http://example.org/share/'
end

def log_in_as_admin
  admin = FactoryGirl.create(:admin)
  log_in admin.email
end

def app
  Sinatra::Application
end

def log_in(email)
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return(email)
end

def logout
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return("")
end
