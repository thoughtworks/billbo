Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require 'io/console'

namespace :server do 
  desc 'run the shotgun server with correct parameters'
  task :run do
    begin 
      conf_file = YAML.load_file(ENV['HOME'] + '/billbo.yml')
      system "billbo_login='#{conf_file['user']}' billbo_password='#{conf_file['password']}' shotgun"
    rescue Errno::ENOENT
      conf_file = ask_user_information
      system "billbo_login='#{conf_file['user']}' billbo_password='#{conf_file['password']}' shotgun"
    end
  end
end

def ask_user_information
  puts 'User:'
  user = STDIN.gets

  puts 'Password:'
  password = STDIN.gets

  {'user' => user, 'password' => password}
end
