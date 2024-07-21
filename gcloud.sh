#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Set variables
projectId="demos-322021"
imageLocation="us-east4"
runLocation="us-central1"
repository="containers"
projectName="pocket-fhir"

# Set the gcloud project
gcloud config set project $projectId

# Define registry location
registryLocation="$imageLocation-docker.pkg.dev/$projectId/$repository/$projectName"

# Build the Docker image
docker build -t $projectName -f build/Dockerfile .

# Tag the Docker image
docker tag $projectName $registryLocation

# Push the tagged image to the Artifact Registry
docker push $registryLocation

# Deploy on Google Cloud Run
gcloud run deploy $projectName --image $registryLocation --platform managed --region $runLocation --allow-unauthenticated \
--update-env-vars PB_ENCRYPTION_KEY=$PB_ENCRYPTION_KEY,AUTO_HTTPS=$AUTO_HTTPS

# Set IAM policy to allow unauthenticated invocations
gcloud run services add-iam-policy-binding $projectName \
  --member="allUsers" \
  --role="roles/run.invoker" \
  --region=$runLocation
