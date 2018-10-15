source 'https://rubygems.org'
source 'https://download:3fa83ff6a8f7574eddd7962c83fb0c2c96b85a5c5be31a2ffa2f7c718e25dcb5@www.phusionpassenger.com/enterprise_gems'
ruby '2.4.0'

# Application engine
gem 'rails', github: 'rails/rails', branch: '5-0-stable'

# Application server
gem 'passenger-enterprise-server', '>= 5.0.22'

# Database adapters
# gem 'pg' # PostgreSQL
# gem 'pg_search' # PostgreSQL full text search

gem 'heroics', '= 0.0.21'

# Web-serving tools
gem 'human_power' # robots.txt DSL
gem 'platform-api'
# gem 'secure_headers' # automatic security headers # TODO: solve the issues it causes first

# Rendering DSLs
gem 'slim-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'jbuilder'
gem 'jquery-ui-rails'
# Rendering helpers
gem 'country_select'
gem 'simple_form'
gem 'inline_svg'
gem 'flutie' # view helpers
gem 'paloma' # page-specific javascripts
gem 'roadie' # inline email stylesheets
gem 'premailer-rails'
gem 'lazybox'
gem 'gon'

# Vendor assets and frameworks
gem 'jquery-rails'
gem 'jquery-fileupload-rails' # background uploads (with shrine and roda) frontend part
# gem 'jquery-atwho-rails'
gem 'animate-rails' # css animations
gem 'bulma-rails', "~> 0.4.2"
gem 'customize-rails'
gem 'gemoji'
gem 'font-awesome-rails'
gem 'bootstrap-popover-rails', '~> 0.1.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-onmount'
  gem 'rails-assets-tether'
  gem 'rails-assets-drop'
  gem 'rails-assets-masked-input'
  gem 'rails-assets-fastclick'
  gem 'rails-assets-sanitize-css', '4.1.0'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-jquery.atwho'
  gem 'rails-assets-jquery-file-upload'
end

gem "uikit-rails" # used for dropdowns etc.
group :assets do
  # DSLs
  gem 'sass-rails'

  # Compilation
  gem 'autoprefixer-rails'
end

# Tracking services
gem 'ahoy_matey' # internal
gem 'coveralls', require: false
gem 'mixpanel-ruby'
gem 'rack-tracker'
gem 'appsignal'
# gem 'newrelic_rpm'
gem 'skylight'
# gem 'scout_apm'
gem 'faraday' # HTTP Client
gem 'slack-notifier'

# External APIs and services
gem 'mailgun_rails'
gem 'soundcloud'
gem 'httparty', '= 0.13.7'
gem 'twitter'
gem 'aws-sdk' # dependency for shrine
gem 'social_shares' # pages sharing stats

# Users management
gem 'hashie', '3.5.3' # fix for https://github.com/omniauth/omniauth/issues/872 until fixed
gem 'bcrypt-ruby'
gem 'has_secure_token'
gem 'omniauth-twitter'

gem 'fastimage'
gem 'mini_magick'
gem 'image_processing'

# Image tools
gem 'cloudinary'
gem 'carrierwave', '< 1.0'
gem 'ufujs-rails'
gem 'carrierwave-base64'
gem 'image_optim'
gem 'image_optim_pack'

# Image generators
gem 'geo_pattern' # backgrounds
gem 'identicon'

# Audio tools
# gem 'taglib-ruby' # metadata processing
gem 'streamio-ffmpeg'
gem 'wavefile', '0.6.0'

# Miscellaneous
gem 'roda' # shrine dependency for background uploading
# gem 'hooks' # ruby extensions
gem 'shrine', '~> 2.5.0' # attachments
gem 'sidekiq' # background jobs
gem 'sidekiq-cron' # background cron jobs
gem 'sidekiq-failures'
# gem 'rollout' # feature flippers
gem 'kaminari' # pagination
# gem 'recommendable' # likes/dislikes engine

gem 'by_star', git: 'https://github.com/radar/by_star.git' # datetime based AR finders
gem 'acts_as_commentable_with_threading'
gem 'shortener'
gem 'nokogiri'
gem 'browser'
gem 'jquery-datatables-rails'  #for dataTables admin pages
gem 'ajax-datatables-rails'
gem 'turbolinks', '~> 5.0.0'
gem 'bootstrap-slider-rails'  #sliderbar
gem 'hammerjs-rails'

# beat forums
gem 'thredded', '0.11.1'

# Development tools to be present in all environments
gem 'awesome_print', require: false # pretty printing for in-console debugging convenience
# gem 'stackprof'
# gem 'rack-mini-profiler'
gem 'memory_profiler'
# gem 'flamegraph'
gem 'rack-cors', require: 'rack/cors'

gem 'mysql2'

group :development do
  gem 'brakeman', require: false
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.2.0'
  gem 'derailed_benchmarks'
  gem 'bullet'
end

group :development, :test do
  gem 'byebug'
  gem 'rubocop'
  gem 'bundler-audit', require: false
  gem 'therubyracer' # for uglifier # unnecessary on Heroku
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
end

gem 'faker' # used in seeds.rb
gem 'rails-controller-testing'
group :test do
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'capybara-email'
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'rspec-retry'
  gem 'timecop'
end

gem 'dalli'
# gem 'kgio' # For faster memcached access
gem 'redis-rails'
gem 'redis-rack-cache'
gem 'connection_pool'
group :staging, :production do
  gem 'pg'
  gem 'pg_search'
  gem 'rails_12factor' # heroku requirement
end
