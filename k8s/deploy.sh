#!/bin/bash

# F3A Microservice K3s Deployment Script

set -e

echo "🚀 Deploying F3A Microservice to K3s..."

# Pull Docker image from GHCR
echo "📦 Pulling Docker image from GHCR..."
docker pull ghcr.io/considerable/f3a-microservice:latest

# Import image to K3s
echo "📥 Importing image to K3s..."
sudo k3s ctr images import <(docker save ghcr.io/considerable/f3a-microservice:latest)

# Apply Kubernetes manifests
echo "☸️ Applying K8s manifests..."
cd ../k8s

# Create namespace
kubectl apply -f namespace.yaml

# Deploy application
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Wait for deployment
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/f3a-app -n f3a-microservice

# Show status
echo "✅ Deployment complete!"
echo ""
echo "📊 Status:"
kubectl get pods -n f3a-microservice
kubectl get svc -n f3a-microservice

echo ""
echo "🌐 Access URLs:"
echo "- Health: http://app.f3a-pattern-aerobatics-rc.club:30080/health"
echo "- Club API: http://app.f3a-pattern-aerobatics-rc.club:30080/api/club"
echo "- Brands API: http://app.f3a-pattern-aerobatics-rc.club:30080/api/brands"

echo ""
echo "🔍 Test commands:"
echo "curl http://app.f3a-pattern-aerobatics-rc.club:30080/health"
echo "curl http://app.f3a-pattern-aerobatics-rc.club:30080/api/brands"
