#!/bin/bash

# Variables
URL="https://whatson-up-d7h4ai6p.wm.gateway.dev/api/user/get_user"
ORIGIN="https://lonfi-1035006743185.us-central1.run.app"

# Test CORS preflight request
echo "Testing CORS preflight request (OPTIONS)..."
curl -i -X OPTIONS $URL \
     -H "Origin: $ORIGIN" \
     -H "Access-Control-Request-Method: GET" \
     -H "Access-Control-Request-Headers: Content-Type, Authorization"

echo -e "\n"

# Test GET request
echo "Testing GET request..."
curl -i -X GET $URL \
     -H "Origin: $ORIGIN" \
     -H "Authorization: Bearer your_token_here" \
     -H "Content-Type: application/json"
