Rails.application.configure do
  config.cache_classes                              = true
  config.eager_load                                 = false
  config.consider_all_requests_local                = true
  config.action_controller.perform_caching          = false
  config.action_dispatch.show_exceptions            = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method              = :test
  config.active_support.deprecation                 = :stderr
  config.active_support.test_order                  = :sorted
  config.action_controller.default_url_options      = { host: 'http://localhost:9887' }
  config.action_mailer.default_url_options          = { host: 'http://localhost:9887' }
  config.action_mailer.asset_host = 'http://localhost:9887'
  config.active_job.queue_adapter = :test
end
