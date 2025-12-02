#!/bin/bash

# SonarQube Scanner Script
# Usage: ./sonar-scan.sh YOUR_SONAR_TOKEN

if [ -z "$1" ]; then
    echo "Error: SonarQube token required"
    echo "Usage: ./sonar-scan.sh YOUR_SONAR_TOKEN"
    exit 1
fi

SONAR_TOKEN=$1
SONAR_HOST_URL="http://sonarqube:9000"

echo "Running Pest tests with coverage..."
vendor/bin/pest --coverage --coverage-clover=build/logs/clover.xml

echo "Fixing coverage file paths..."
# Replace Docker paths (/app/app/) with relative paths (app/)
sed -i 's|name="/app/app/|name="app/|g' build/logs/clover.xml
sed -i 's|name="/app/routes/|name="routes/|g' build/logs/clover.xml
sed -i 's|name="/app/config/|name="config/|g' build/logs/clover.xml
sed -i 's|name="/app/database/|name="database/|g' build/logs/clover.xml

echo "Running SonarQube analysis..."
docker run --rm \
    --network laravel-pilot-app_laravel \
    -v "$(pwd):/usr/src" \
    sonarsource/sonar-scanner-cli \
    -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.token=${SONAR_TOKEN}

echo "Analysis complete! Check http://localhost:9000"
