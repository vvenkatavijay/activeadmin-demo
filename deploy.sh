#!/bin/bash

# ActiveAdmin Docker Deployment Script
set -e

echo "🚀 Starting ActiveAdmin deployment..."

# Build the Docker image
echo "📦 Building Docker image..."
cd tmp/development_apps/rails_80
docker build -t activeadmin-app .
cd ../../..

# Stop and remove existing containers
echo "🛑 Stopping existing containers..."
docker-compose down || true

# Start the application
echo "🚀 Starting ActiveAdmin application..."
docker-compose up -d

# Wait for the application to start
echo "⏳ Waiting for application to start..."
sleep 10

# Check if the application is running
echo "🔍 Checking application health..."
if curl -f http://localhost:3000/admin > /dev/null 2>&1; then
    echo "✅ ActiveAdmin is running successfully!"
    echo "🌐 Access your application at: http://localhost:3000"
    echo "🔐 Admin login: admin@example.com / password"
else
    echo "❌ Application failed to start. Check logs with: docker-compose logs"
    exit 1
fi

echo "🎉 Deployment complete!"
