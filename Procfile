web: bundle exec passenger start -p $PORT --max-pool-size 3 --nginx-config-template ./config/nginx.conf.erb
worker: bundle exec sidekiq -q default -q mailers
