# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :senju do
  desc "senju define script"
  task :importjar => :environment do
    SenjuJob.all.each do |j|
      print "job =================> #{j.name}\n"
    end
  end
end
