Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require './app'

namespace :admin do
  desc 'Creates an admin with the given email'

  task :new, [:email] do |t, args|
    if args[:email]
      Admin.create!(:email => args[:email])
      puts "Admin #{args[:email]} created"
    end
  end
end
