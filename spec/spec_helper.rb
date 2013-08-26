# encoding: UTF-8

ENV['RACK_ENV'] ||= 'test'

require './app'
require 'capybara'
require 'pony'

require 'factory_girl'
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:each) do
    Pony.stub(:deliver)
    setup_carrierwave
  end

  config.after(:each) do
    # FIXME Why we need to to this manually?
    Mongoid.default_session.collections.each { |coll| coll.drop unless /^system/.match(coll.name) }
    FileUtils.rm_rf(Dir[File.join(File.dirname(__FILE__), "../public/#{FileUploader.store_dir}/[^.]*")])
  end
end

def setup_carrierwave
  CarrierWave::Uploader::GoogleDrive.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

def homepage
  'http://example.org/'
end

def log_in_as_admin
  admin = FactoryGirl.create(:admin)
  log_in admin.email
end

def log_in(email)
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return(email)
end

def logout
  Sinatra::Application.any_instance.stub(:logged_in_email).and_return("")
end
