#!/bin/sh

# Use the PORT environment variable or default to 8090
PORT=${PORT:-8090}

# Start the PocketBase server
/app/pocketfhir serve --http=0.0.0.0:$PORT --dir=/cloud/storage/pb_data --publicDir=/cloud/storage/pb_public --hooksDir=/cloud/storage/pb_hooks &

# Wait for PocketBase to be ready
while ! nc -z 127.0.0.1 $PORT; do
  echo "Waiting for PocketBase to be ready on port $PORT..."
  sleep 2
done

echo "PocketBase is ready, starting Caddy..."

# Start the Caddy server
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
