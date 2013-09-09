#!/usr/bin/env ruby

spec_commands = ["bundle exec rspec spec",
                 "cucumber -f progress"]

deploy_commands = ["git checkout master",
                   "af target https://api1.appfog.com",
                   "af login --email ${AF_EMAIL} --passwd ${AF_PASSWORD}",
                   "af update billbo",
                   "af logout"]

def run(commands)
  commands.each do |command|
    system(command)
  end
end

run(spec_commands)

if ENV["TRAVIS_BRANCH"] == "master"
  puts "Running deploy process"
  run(deploy_commands)
end
