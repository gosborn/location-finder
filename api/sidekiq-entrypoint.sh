#!/bin/sh
# if you see errors regarding this file on `docker-compose up`
# the permissions of this file may need to be changed

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec sidekiq