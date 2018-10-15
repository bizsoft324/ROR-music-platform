Rails.application.config.serve_static_files = true

Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.precompile += %w(pages/waitlist.js image_preview.js)
Rails.application.config.assets.precompile << /\.(?:gif|png|svg|ttf|woff|woff2|jpg)\z/
Rails.application.config.public_file_server.headers = { 'Cache-Control' => 'public, s-maxage=15552000, max-age=2592000' }