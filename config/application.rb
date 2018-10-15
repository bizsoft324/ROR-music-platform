require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

module Beat
  class Application < Rails::Application
    config.generators do |g|
      g.assets   = false
      g.helper   = false
      g.jbuilder = false
    end

    console do
      require_relative '../lib/patches/irb' if defined? IRB
      require 'awesome_print'
      # AwesomePrint.defaults = { raw: true } #, limit: true, sort_keys: true
      AwesomePrint.irb!
      AwesomePrint.pry!
    end

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.middleware.use JQuery::FileUpload::Rails::Middleware
    config.active_record.raise_in_transactional_callbacks = true

    config.secret_key_base = ENV['SECRET_KEY_BASE'].presence
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq
  end
end

Rails.application.secrets.each { |key, value| ENV[key.to_s] ||= value.to_s }

require_relative '../lib/utility/shrine'
require_relative '../lib/constraints/custom_domain_constraint.rb'