#!/bin/bash

# Navigate to the root directory of the project
cd "$(dirname "$0")/.."

# Clean up previous builds
# rm -rf data/pb_data data/pb_migrations 
rm pocketfhir

# Initialize Go modules in the root directory if go.mod does not exist
if [ ! -f go.mod ]; then
    go mod init pocketfhir
fi

# Tidy up Go modules in the root directory
go mod tidy

# Build the PocketBase server and place the executable in the root directory
CGO_ENABLED=0 go build -o pocketfhir ./src
