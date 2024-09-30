#!/bin/bash

# Create and write environment variables to .env files for changed services
if [ "${backend_changed}" == "true" ]; then
  echo "${SPRINGBOOT_ENV}" > src/Backend/.env
fi

if [ "${analytics_changed}" == "true" ]; then
  echo "${SPRINGBOOT_ENV}" > src/Analytics/.env
fi

if [ "${recommendations_changed}" == "true" ]; then
  echo "${RECOMMENDATIONS_ENV}" > src/recommendation-service/.env
fi

if [ "${notifications_changed}" == "true" ]; then
  echo "${NOTIFICATIONS_ENV}" > src/notification-service/.env
fi

if [ "${storage_changed}" == "true" ]; then
  echo "${NOTIFICATIONS_ENV}" > src/storage-service/.env
fi
