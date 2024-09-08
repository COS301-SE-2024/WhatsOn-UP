@echo off
:: Run analytics service

gradle bootrun || (
    echo gradle bootrun failed for API service
    exit /b 1
)

echo npm run start executed successfully
exit /b 0