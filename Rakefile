namespace :db do
  task :seed do
    seed_file = File.join(File.dirname(__FILE__), 'db', 'seed.rb')
    load(seed_file) if File.exist?(seed_file)
  end
end
