#!/bin/bash

# Define variables
DOCKER_HUB_REPO="devforce123/backend-services"
GCR_REPO="us-east1-docker.pkg.dev/whatsonup/backend-services"
SERVICE_NAME="analytics"
WORKING_DIR="../src/Analytics"

echo "Deploying ${SERVICE_NAME}..."

# Navigate to the service's directory
cd "${WORKING_DIR}" || exit

# Build Docker image
docker build -t "${DOCKER_HUB_REPO}:${SERVICE_NAME}" .

# Tag the image for Google Container Registry (GCR)
docker tag "${DOCKER_HUB_REPO}:${SERVICE_NAME}" "${GCR_REPO}/${SERVICE_NAME}:latest"

# Push to GCR
docker push "${GCR_REPO}/${SERVICE_NAME}:latest"

# Push to Docker Hub
docker push "${DOCKER_HUB_REPO}:${SERVICE_NAME}"

# Deploy to Google Cloud Run
gcloud run services update "${SERVICE_NAME}" \
  --image "${GCR_REPO}/${SERVICE_NAME}:latest" \
  --region us-central1 

echo "${SERVICE_NAME} deployment completed."
