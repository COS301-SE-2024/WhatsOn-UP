#!/bin/bash

# Define variables
DOCKER_HUB_REPO="devforce123/backend-services"
GCR_REPO="us-east1-docker.pkg.dev/whatsonup/backend-services"

# Arrays for service names and their respective directories
services=("api" "storage" "notifications" "analytics" "recommendations")
directories=("../src/Backend" "../src/storage-service" "../src/notification-service" "../src/Analytics" "../src/recommendation-service")

# Loop through services and directories
for i in "${!services[@]}"; do
  SERVICE_NAME=${services[$i]}
  WORKING_DIR=${directories[$i]}
  
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
    --image "${GCR_REPO}/${SERVICE_NAME}:latest"

  # Return to the original directory
  cd - || exit

  echo "${SERVICE_NAME} deployment completed."
done

echo "Deploying notifications-live..."

gcloud run services update notifications-live \
  --image us-east1-docker.pkg.dev/whatsonup/backend-services/notifications:latest \
  --region us-central1 

echo "notifications-live deployment completed."

echo "All backend services deployed successfully."

# Deploy frontend service
echo "Deploying frontend service..."

# Navigate to the Frontend directory
cd "../src/Frontend" || exit

# Build the Flutter web app
flutter build web

# Copy Dockerfile to Build/web directory
cp Dockerfile build/web

# Navigate to Build/web directory
cd build/web || exit

# Build Docker image for frontend
docker build -t devforce123/frontend-services:latest .

# Tag the image for Google Container Registry (GCR)
docker tag devforce123/frontend-services:latest us-east1-docker.pkg.dev/whatsonup/backend-services/frontend:latest

# Push to Google Container Registry (GCR)
docker push us-east1-docker.pkg.dev/whatsonup/backend-services/frontend:latest

# Push to Docker Hub
docker push devforce123/frontend-services:latest

# Deploy to Google Cloud Run
gcloud run services update frontend \
  --image us-east1-docker.pkg.dev/whatsonup/backend-services/frontend:latest \
  --region us-central1 

echo "Frontend service deployment completed."
