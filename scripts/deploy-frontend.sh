#!/bin/bash

# Define variables
DOCKER_HUB_REPO="devforce123/frontend-services"
GCR_REPO="us-east1-docker.pkg.dev/whatsonup/backend-services"
SERVICE_NAME="frontend"
WORKING_DIR="../src/Frontend"

echo "Deploying ${SERVICE_NAME}..."

# Navigate to the Frontend directory
cd "${WORKING_DIR}" || exit


# Install dependencies for Frontend
flutter pub get

# Build the Flutter web app
flutter build web

# Copy Dockerfile to Build/web directory
cp Dockerfile build/web

# Navigate to Build/web directory
cd build/web || exit

# Build Docker image for frontend
docker build -t "${DOCKER_HUB_REPO}:latest" .

# Tag the image for Google Container Registry (GCR)
docker tag "${DOCKER_HUB_REPO}:latest" "${GCR_REPO}/${SERVICE_NAME}:latest"

# Push to Google Container Registry (GCR)
docker push "${GCR_REPO}/${SERVICE_NAME}:latest"

# Push to Docker Hub
docker push "${DOCKER_HUB_REPO}:latest"

# Deploy to Google Cloud Run
gcloud run services update "${SERVICE_NAME}" \
  --image "${GCR_REPO}/${SERVICE_NAME}:latest" \
  --region us-central1 

echo "${SERVICE_NAME} deployment completed."
