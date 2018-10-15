domain = if Rails.env  == 'production'
  'https://beatthread.com'
else
  case ENV['HEROKU_APP_NAME']
  when 'beat-thread-staging', 'beat-thread-beta' then 'https://beatthread.studio'
  when 'beat-thread-testing' then 'https://beatthread.biz'
  end
end

Rails.application.config.middleware.use CloudfrontConstraint, target: domain
