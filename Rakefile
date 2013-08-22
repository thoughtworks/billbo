#!/usr/bin/env rake
## Add custom tasks in files placed in lib/tasks ending in .rake,

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/*.rake')].each { |f| load f }

namespace :bill do
  task :update_reservations_status do
    Bill.update_reservations_status
  end
end