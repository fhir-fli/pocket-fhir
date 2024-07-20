#!/bin/bash

# Navigate to the root directory of the project
cd "$(dirname "$0")/.."

# Clean up previous builds
rm -f pocketfhir

# Initialize Go modules in the root directory if go.mod does not exist
if [ ! -f go.mod ]; then
    go mod init pocketfhir
fi

# Tidy up Go modules in the root directory
go mod tidy

# Build the PocketBase server and place the executable in the root directory
CGO_ENABLED=0 go build -o pocketfhir ./src

# Start the PocketBase server in the background
./pocketfhir serve &
PB_PID=$!

# Wait for the pb_migrations and pb_data directories to be generated
while [ ! -d "./pb_migrations" ] || [ ! -d "./pb_data" ]; do
  echo "Waiting for pb_migrations and pb_data directories to be generated..."
  sleep 5
done

# Stop the PocketBase server
kill $PB_PID

# Copy the generated directories to the data directory
cp -r ./pb_migrations ./data/pb_migrations
cp -r ./pb_data ./data/pb_data

echo "PocketFHIR build completed successfully."
