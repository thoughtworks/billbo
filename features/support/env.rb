require File.join(File.dirname(__FILE__), '..', '..', 'app')
require 'Capybara'
require 'Capybara/cucumber'
require 'factory_girl'
require './spec/factories'
require 'rspec'

Capybara.app = eval("Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/../../config.ru') + "\n )}")

class SomeWorld
  include Capybara
  include RSpec::Expectations
  include RSpec::Matchers
end

After do
  REDIS.del 'bills'
  REDIS.keys('bills:*').each { |key| REDIS.del key }
  REDIS.del 'ids:bills'
end

World do
  SomeWorld.new
end
