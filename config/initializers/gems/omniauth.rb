Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], secure_image_url: 'true', image_size: 'original', authorize_params: { force_login: 'true' }
end

OmniAuth.config.on_failure = -> (env) do
  Rack::Response.new(['302 Moved'], 302, 'Location' => '/').finish
end
