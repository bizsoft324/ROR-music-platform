# This file is used by Rack-based servers to start the application.
require 'rack'
require 'rails'

require ::File.expand_path('../config/environment', __FILE__)
use Rack::Deflater

run Rails.application
