#!/bin/bash

# Generate Coverage Script (run inside container)
# Usage: ./generate-coverage.sh

echo "Running Pest tests with coverage..."
vendor/bin/pest --coverage --coverage-clover=build/logs/clover.xml

echo "Fixing coverage file paths..."
# Replace Docker paths (/app/app/) with relative paths (app/)
sed -i 's|name="/app/codebase/backend/app/|name="app/|g' build/logs/clover.xml
sed -i 's|name="/app/app/|name="app/|g' build/logs/clover.xml
sed -i 's|name="/app/routes/|name="routes/|g' build/logs/clover.xml
sed -i 's|name="/app/config/|name="config/|g' build/logs/clover.xml
sed -i 's|name="/app/database/|name="database/|g' build/logs/clover.xml

echo "Coverage generated at build/logs/clover.xml"
echo "File paths have been fixed for SonarQube"
