ENV['RACK_ENV'] ||= 'test'

require './app'
require 'capybara'
require 'pony'

include R18n::Helpers
R18n.default_places = '../i18n/'
R18n.set('pt')

# Load FactoryGirl definitions
require 'factory_girl'
FactoryGirl.find_definitions

# Clean database after running tests
RSpec.configure do |config|
  config.include Mongoid::Matchers
  config.before(:each) do
    do_not_send_email
  end
  config.after(:each) do
    Mongoid.default_session.collections.each { |coll| coll.drop unless /^system/.match(coll.name) }
    FileUtils.rm_rf(Dir[File.join(File.dirname(__FILE__), "../public/#{FileUploader.store_dir}/[^.]*")])
  end
end

def do_not_send_email
  Pony.stub :deliver
end

def homepage
  'http://example.org/'
end
  
def log_in_as_admin
  admin = FactoryGirl.create(:admin)
  log_in admin.email
end

def log_in email
  set_cookie "stub_email=#{email}"
end

def logout
  set_cookie ''
end
