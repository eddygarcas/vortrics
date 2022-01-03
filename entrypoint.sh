#!/bin/sh
# Compile the assets
#bundle exec rake assets:precompile
set -e
if [ -f /vortrics/db/development.sqlite3 ]; then
  echo "Database already created"
else
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:seed
fi

if [ -f /vortrics/tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0


