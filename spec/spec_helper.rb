require './app.rb'
require 'factory_girl'
require './spec/factories'
require 'capybara'

Mongoid.load!('./config/mongoid.yml', :test)

# Clean database after running tests
RSpec.configure do |config|
  config.after(:each) do
    Mongoid.default_session.collections.each { |coll| coll.drop unless /^system/.match(coll.name) }
  end
end
