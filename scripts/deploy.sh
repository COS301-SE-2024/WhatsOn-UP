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

  # Return to the original directory
  cd - || exit

  echo "${SERVICE_NAME} deployment completed."
done

echo "All services deployed successfully."
