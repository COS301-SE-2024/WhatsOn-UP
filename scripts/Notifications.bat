@echo off
:: Run notification service

npm run start:dev || (
    echo 'npm run start:dev' failed for notification service
    exit /b 1
)

echo Notification service started successfully