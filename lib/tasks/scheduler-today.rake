desc 'This task is called by the Heroku scheduler add-on once an hour'
task chart_tracks: :environment do
  puts 'updating charts for today...'
  Track::Day.chart
end

desc 'this task is called to reset charts without sending emails'
task no_email_chart_tracks: :environment do
  puts 'turning off ActionMailer'
  ActionMailer::Base.perform_deliveries = false
  puts 'updating charts for today...'
  Track::Day.chart
  ActionMailer::Base.perform_deliveries = true
end
