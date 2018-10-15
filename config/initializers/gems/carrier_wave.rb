CarrierWave.configure do |config|
  config.enable_processing = !Rails.env.test?
end
