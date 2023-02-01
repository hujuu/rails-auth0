#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid
mkdir -p tmp/sockets
mkdir -p tmp/pids

bundle exec rails assets:precompile RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"