Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

namespace :test do

  desc 'Runs unit tests'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end

  desc 'Runs functional tests'
  Cucumber::Rake::Task.new(:functional) do |t|
    t.cucumber_opts = '--format pretty --tags ~@wip'

  end

  desc 'Runs all tests'
  task :all => [:unit, :functional]

end
