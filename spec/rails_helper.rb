require 'simplecov'
SimpleCov.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'
require 'capybara-screenshot/rspec'
require 'rspec/retry'
require 'slack-notifier'
Rails.application.config.active_job.queue_adapter = :inline

ActiveRecord::Migration.maintain_test_schema!
DEFAULT_PORT = 9887

Capybara.default_driver     = :poltergeist
Capybara.javascript_driver  = :poltergeist
Capybara.asset_host         = 'http://localhost:3000'
Capybara.server_port        = DEFAULT_PORT
Capybara.app_host           = "http://lvh.me:#{Capybara.server_port}"
Capybara.default_max_wait_time = 15

Phantomjs.path
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path, window_size: [1920, 6000], js_errors: false)
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RandomString
  config.include(OmniauthMacros)
  config.include(ActiveJob::TestHelper)

  config.verbose_retry                = true
  config.display_try_failure_messages = true

  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test"])
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = false

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
