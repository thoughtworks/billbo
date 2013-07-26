ENV['RACK_ENV'] ||= 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app')
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
  Mongoid.default_session.collections.each { |coll| coll.drop unless /^system/.match(coll.name) }
end

World do
  SomeWorld.new
end
