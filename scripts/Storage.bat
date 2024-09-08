@echo off
:: Run storage service

npm run start:dev || (
    echo 'npm run start:dev' failed for storage service
    exit /b 1
)

echo npm run start executed successfully
exit /b 0