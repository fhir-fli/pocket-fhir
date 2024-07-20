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
./pocketfhir serve

echo "PocketFHIR build completed successfully."
