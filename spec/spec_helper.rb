ENV['RACK_ENV'] ||= 'test'

require './app'
require 'capybara'

# Load FactoryGirl definitions
require 'factory_girl'
FactoryGirl.find_definitions

# Clean database after running tests
RSpec.configure do |config|
  config.after(:each) do
    Mongoid.default_session.collections.each { |coll| coll.drop unless /^system/.match(coll.name) }
  end
end
