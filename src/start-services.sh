#!/bin/bash

# Start the backend service
cd /home/ubuntu/backend
./gradlew bootRun &

# Start the storage-service
cd /home/ubuntu/storage-servic
npm start &

# Start the notification-service
cd /home/ubuntu/notification-service
npm start &

# Start the gateway service
cd /home/ubuntu/gateway
./gradlew bootRun &

# Wait for all background processes to finish
wait
