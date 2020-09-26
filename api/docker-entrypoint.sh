#!/usr/bin/env bash
# if you see errors regarding this file on `docker-compose up`
# the permissions of this file may need to be changed
set -e

# https://stackoverflow.com/a/38732187/1935918
if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

rails db:migrate 2>/dev/null || rails db:setup

exec bundle exec "$@"