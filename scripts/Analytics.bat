@echo off
:: Run analytics service

gradlew bootrun || (
    echo gradle bootrun failed for Analytics service
    exit /b 1
)

echo npm run start executed successfully
exit /b 0