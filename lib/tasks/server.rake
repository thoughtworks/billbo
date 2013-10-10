Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

require 'yaml/store'

namespace :server do 
  desc 'run the shotgun server with correct parameters'
  task :run do
    begin 
      conf_file = YAML.load_file(ENV['HOME'] + '/.billbo.yml')
    rescue Errno::ENOENT
      conf_file = ask_user_information
    end

    system "billbo_login='#{conf_file['user']}' billbo_password='#{conf_file['password']}' shotgun"
  end
end

def ask_user_information
  puts 'User:'
  user = STDIN.gets

  puts 'Password:'
  password = STDIN.gets

  user_information = {'user' => user, 'password' => password}
 
  store_information(user_information)
  user_information
end

def store_information(info) 
  store = YAML::Store.new(ENV['HOME'] + '/.billbo.yml')

  store.transaction do
    store["user"] = info["user"]
    store["password"] = info["password"]
  end
end
