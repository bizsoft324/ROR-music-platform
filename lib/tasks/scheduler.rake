desc 'This task is called by the Heroku scheduler add-on'
task chart_tracks: :environment do
  puts 'updating charts for this week...'
  Track::Week.chart
  puts 'updating charts for this month....'
  Track::Month.chart
  puts 'updating charts for all time...'
  Track::AllTime.chart
  puts 'processing emails...'
  User.select(&:email_data?).each(&:send_daily_emails)
  User.update_all(email_data: {})
end

desc 'this task is called to reset charts without sending emails'
task no_email_chart_tracks: :environment do
  puts 'updating charts for this week...'
  Track::Week.chart
  puts 'updating charts for this month....'
  Track::Month.chart
  puts 'updating charts for all time...'
  Track::AllTime.chart
end
