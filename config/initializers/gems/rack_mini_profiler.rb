if defined? Rack::MiniProfiler
	Rack::MiniProfiler.config.storage = Rack::MiniProfiler::FileStore # Using FileStore stince memorystore is broken with Rails 4.2 and results in 404s
	Rack::MiniProfiler.config.storage_options = { path: './tmp' }
end