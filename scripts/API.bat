@echo off
:: Run spring boot
REM Run gradle
gradle bootrun || (
    echo gradle bootrun failed for API service
    exit /b 1
)

echo gradle bootrun executed successfully