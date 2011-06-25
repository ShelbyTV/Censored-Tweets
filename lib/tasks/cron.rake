desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  #if this wasn't only run at midnight, would want to wrap with
  # if Time.now.hour == 0 .... end
  Winner.declare_winner!
  User.decay_points!
end