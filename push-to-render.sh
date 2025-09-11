#!/bin/bash

# Push ActiveAdmin Docker image to registry for Render deployment
set -e

echo "🚀 Preparing ActiveAdmin for Render deployment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Get username (default to GitHub username if available)
if [ -z "$1" ]; then
    echo "Usage: ./push-to-render.sh <your-username> [registry]"
    echo "Example: ./push-to-render.sh johndoe"
    echo "Example: ./push-to-render.sh johndoe dockerhub"
    echo "Example: ./push-to-render.sh johndoe ghcr"
    exit 1
fi

USERNAME=$1
REGISTRY=${2:-"dockerhub"}  # Default to Docker Hub

# Set registry details
if [ "$REGISTRY" = "ghcr" ]; then
    REGISTRY_URL="ghcr.io"
    IMAGE_NAME="$REGISTRY_URL/$USERNAME/activeadmin-app"
    echo "📦 Using GitHub Container Registry: $IMAGE_NAME"
else
    REGISTRY_URL="docker.io"
    IMAGE_NAME="$USERNAME/activeadmin-app"
    echo "📦 Using Docker Hub: $IMAGE_NAME"
fi

# Check if image exists
if ! docker images | grep -q "activeadmin-app.*latest"; then
    echo "❌ activeadmin-app:latest image not found. Building first..."
    ./deploy.sh
fi

echo "🏷️  Tagging image for $REGISTRY_URL..."
docker tag activeadmin-app:latest $IMAGE_NAME:latest

echo "🔐 Please login to $REGISTRY_URL..."
if [ "$REGISTRY" = "ghcr" ]; then
    echo "You can use a GitHub Personal Access Token with 'packages:write' permission"
    echo "Run: echo \$GITHUB_TOKEN | docker login ghcr.io -u $USERNAME --password-stdin"
    docker login ghcr.io -u $USERNAME
else
    docker login
fi

echo "📤 Pushing image to $REGISTRY_URL..."
docker push $IMAGE_NAME:latest

echo "✅ Successfully pushed $IMAGE_NAME:latest"
echo ""
echo "🎯 Next steps:"
echo "1. Go to https://dashboard.render.com"
echo "2. Create a new Web Service"
echo "3. Connect your GitHub repository"
echo "4. Use Docker deployment with image: $IMAGE_NAME:latest"
echo "5. Set environment variables as described in RENDER_DEPLOYMENT.md"
echo ""
echo "🌐 Your image is now available at:"
echo "   https://$REGISTRY_URL/$USERNAME/activeadmin-app"
