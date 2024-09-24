#!/bin/bash

# Check if specific services have changes
if git diff --quiet HEAD^ HEAD -- src/Backend; then
  echo "backend_changed=false" >> $GITHUB_ENV
else
  echo "backend_changed=true" >> $GITHUB_ENV
fi

if git diff --quiet HEAD^ HEAD -- src/storage-service; then
  echo "storage_changed=false" >> $GITHUB_ENV
else
  echo "storage_changed=true" >> $GITHUB_ENV
fi

if git diff --quiet HEAD^ HEAD -- src/notification-service; then
  echo "notifications_changed=false" >> $GITHUB_ENV
else
  echo "notifications_changed=true" >> $GITHUB_ENV
fi

if git diff --quiet HEAD^ HEAD -- src/Analytics; then
  echo "analytics_changed=false" >> $GITHUB_ENV
else
  echo "analytics_changed=true" >> $GITHUB_ENV
fi

if git diff --quiet HEAD^ HEAD -- src/recommendation-service; then
  echo "recommendations_changed=false" >> $GITHUB_ENV
else
  echo "recommendations_changed=true" >> $GITHUB_ENV
fi

if git diff --quiet HEAD^ HEAD -- src/Frontend; then
  echo "frontend_changed=false" >> $GITHUB_ENV
else
  echo "frontend_changed=true" >> $GITHUB_ENV
fi
