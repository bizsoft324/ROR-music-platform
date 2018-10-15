Requirements

* Redis Server
* PostgreSQL

Setup

* git clone git@github.com:BeatThread/beat-thread.git
* cd beat-thread
* bundle install
* brew install imagemagick && brew install ffmpeg
* brew install memcached
* cp config/database.yml.example config/database.yml
* cp config/secrets.yml.example config/secrets.yml
* rake db:create db:migrate
* rake db:seed


Run in Development

* $ rails s
* $ redis-server
