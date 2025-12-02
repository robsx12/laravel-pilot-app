#!/bin/bash

# SonarQube Upload Script (run from host)
# Usage: ./sonar-upload.sh YOUR_SONAR_TOKEN

if [ -z "$1" ]; then
    echo "Error: SonarQube token required"
    echo "Usage: ./sonar-upload.sh YOUR_SONAR_TOKEN"
    exit 1
fi

SONAR_TOKEN=$1
SONAR_HOST_URL="http://sonarqube:9000"

echo "Step 1: Generating coverage inside container..."
docker exec laravel-frankenphp /app/generate-coverage.sh

echo ""
echo "Step 2: Running SonarQube analysis..."
docker run --rm \
    --network laravel-pilot-app_laravel \
    -v "$(pwd)/codebase/backend:/usr/src" \
    sonarsource/sonar-scanner-cli \
    -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.token=${SONAR_TOKEN}

echo ""
echo "✅ Analysis complete! Check http://localhost:9000"
