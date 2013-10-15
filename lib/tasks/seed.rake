Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require './app'
require './spec/factories'

namespace :db do
  desc 'Seeds the database with bills <n> times'
  task :seed, [:n] do |t, args|
    clear_all
    puts "Admin created:\n#{FactoryGirl.create(:admin).inspect}\n\n"
    num = args[:n] ? args[:n].to_i : 1

    5.times do
      new_ngo = FactoryGirl.create(:ngo_with_bills, bills_count: num)
      puts "NGO created:\n#{new_ngo.inspect}"
    end
  end
end

def clear_all
  Admin.delete_all
  Ngo.delete_all
  Bill.delete_all
end
