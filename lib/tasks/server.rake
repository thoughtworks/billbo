Bundler.require
$: << File.join(File.dirname(__FILE__), '..')

namespace :server do 
  desc 'run the shotgun server with correct parameters'
  task :run do
    conf_file = YAML.load_file(ENV['HOME'] + '/billbo.yml')
    system "billbo_login='#{conf_file['user']}' billbo_password='#{conf_file['password']}' shotgun"
  end
end
