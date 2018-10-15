# Rack::MiniProfiler.config.disable_caching = false # defaults to true
Rails.application.configure do
  config.skylight.environments += ['staging']
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = true
  config.assets.digest = true
  config.action_controller.asset_host = 'https://' + ENV['CLOUDFRONT_URL']
  config.log_level = :info
  config.assets.js_compressor = :uglifier
  config.cache_store = :redis_store, ENV['REDISTOGO_URL']
  Rails.application.config.public_file_server.enabled = true
  Rails.application.config.public_file_server.headers = { 'Cache-Control': 'public, s-maxage=15552000, max-age=2592000'}

  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '/assets/*', headers: :any, methods: [:get]
    end
  end


  config.action_mailer.default_url_options = { host: 'beatthread.studio' }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
      api_key: ENV['MAILGUN_SECRET_KEY'],
      domain: 'beatthread.com'
  }
  config.active_job.queue_adapter = :sidekiq
  config.action_mailer.smtp_settings = {
      address: 'smtp.mailgun.org',
      authentication: :plain,
      port:       465,
      ssl:        true,
      domain:     ENV['MAILGUN_DOMAIN'],
      user_name:  ENV['MAILGUN_USERNAME'],
      password:   ENV['MAILGUN_PASSWORD']
  }
end
