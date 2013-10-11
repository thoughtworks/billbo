Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require './app'
require './spec/factories'

namespace :db do
  desc 'Seeds the database with bills <n> times'
  task :seed, [:n] do |t, args|
    clear_all
    num = args[:n] ? args[:n].to_i : 1
    num.times {
      puts "Bill created:\n#{FactoryGirl.create(:bill).inspect}\n\n"
    }
    puts "Admin created:\n#{FactoryGirl.create(:admin).inspect}\n\n"
    puts "Ngo created:\n#{FactoryGirl.create(:ngo).inspect}\n\n"
  end
end

def clear_all
  Admin.delete_all
  Ngo.delete_all
  Bill.delete_all
end
