desc "This task is called by the Heroku scheduler add-on"
task :refresh_feed => :environment do
  puts "Updating feed..."
  ApplicationJob.perform_now
  puts "done."
end