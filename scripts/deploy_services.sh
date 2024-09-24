#!/bin/bash

# Deploy services based on which ones had changes

if [ "${backend_changed}" == "true" ]; then
  echo "Deploying API service..."
  ./scripts/deploy-api.sh
fi

if [ "${analytics_changed}" == "true" ]; then
  echo "Deploying Analytics service..."
  ./scripts/deploy-analytics.sh
fi

if [ "${recommendations_changed}" == "true" ]; then
  echo "Deploying Recommendations service..."
  ./scripts/deploy-recommendations.sh
fi

if [ "${notifications_changed}" == "true" ]; then
  echo "Deploying Notifications service..."
  ./scripts/deploy-notifications.sh
fi

if [ "${storage_changed}" == "true" ]; then
  echo "Deploying Storage service..."
  ./scripts/deploy-storage.sh
fi

if [ "${frontend_changed}" == "true" ]; then
  echo "Deploying Frontend service..."
  ./scripts/deploy-frontend.sh
fi

echo "Deployment of changed services
