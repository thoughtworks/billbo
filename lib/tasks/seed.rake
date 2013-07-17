Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require './app'
require './spec/factories'

namespace :db do
  desc 'Seeds the database with bills <n> times'
  task :seed, [:n] do |t, args|
    num = args[:n] ? args[:n].to_i : 1
    num.times {
      puts "Bill created:\n#{FactoryGirl.create(:bill).inspect}\n\n"
    }
  end
end
