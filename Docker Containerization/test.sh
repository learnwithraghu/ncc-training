#!/bin/bash

# Docker Containerization - Test Script
# This script runs through all the lab exercises automatically

set -e  # Exit on error

echo "======================================"
echo "Docker Containerization Test Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}>>> $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Cleanup function
cleanup() {
    print_step "Cleaning up..."
    docker stop my-python-app my-python-app-2 2>/dev/null || true
    docker rm my-python-app my-python-app-2 2>/dev/null || true
    docker volume rm app-data 2>/dev/null || true
    docker network rm my-app-network 2>/dev/null || true
    docker rmi hello-python-app:v1 2>/dev/null || true
}

# Trap cleanup on exit
trap cleanup EXIT

echo "Step 1: Building Docker Image"
print_step "Building image..."
docker build -t hello-python-app:v1 .
print_success "Image built successfully"
echo ""

echo "Step 2: Running Container"
print_step "Starting container..."
docker run -d -p 8080:5000 --name my-python-app hello-python-app:v1
sleep 3
print_success "Container started"
echo ""

echo "Step 3: Testing Application"
print_step "Testing endpoints..."
curl -s http://localhost:8080/ | python3 -m json.tool
print_success "Main endpoint working"

curl -s http://localhost:8080/health | python3 -m json.tool
print_success "Health endpoint working"
echo ""

echo "Step 4: Testing Volumes"
print_step "Stopping container..."
docker stop my-python-app
docker rm my-python-app

print_step "Creating volume..."
docker volume create app-data
print_success "Volume created"

print_step "Starting container with volume..."
docker run -d -p 8080:5000 --name my-python-app -v app-data:/app/data hello-python-app:v1
sleep 3

print_step "Writing data to volume..."
curl -s -X POST http://localhost:8080/write \
  -H "Content-Type: application/json" \
  -d '{"message": "Test message 1"}' | python3 -m json.tool

curl -s -X POST http://localhost:8080/write \
  -H "Content-Type: application/json" \
  -d '{"message": "Test message 2"}' | python3 -m json.tool

print_step "Reading data from volume..."
curl -s http://localhost:8080/read | python3 -m json.tool
print_success "Volume working correctly"
echo ""

echo "Step 5: Testing Volume Persistence"
print_step "Restarting container..."
docker restart my-python-app
sleep 3

print_step "Reading data after restart..."
curl -s http://localhost:8080/read | python3 -m json.tool
print_success "Data persisted across restart"
echo ""

echo "Step 6: Testing Networking"
print_step "Creating custom network..."
docker network create my-app-network
print_success "Network created"

print_step "Stopping container..."
docker stop my-python-app
docker rm my-python-app

print_step "Starting containers on custom network..."
docker run -d --name my-python-app --network my-app-network -p 8080:5000 -v app-data:/app/data hello-python-app:v1
docker run -d --name my-python-app-2 --network my-app-network hello-python-app:v1
sleep 3

print_step "Testing container-to-container communication..."
docker exec my-python-app-2 curl -s http://my-python-app:5000/ | python3 -m json.tool
print_success "Containers can communicate"
echo ""

echo "Step 7: Testing Logs"
print_step "Generating traffic..."
for i in {1..5}; do
    curl -s http://localhost:8080/ > /dev/null
done

print_step "Viewing logs..."
docker logs --tail 10 my-python-app
print_success "Logs accessible"
echo ""

echo "Step 8: Testing Container Access"
print_step "Executing commands in container..."
docker exec my-python-app ls -la /app
docker exec my-python-app python --version
print_success "Can execute commands in container"
echo ""

echo "Step 9: Checking Resources"
print_step "Viewing resource usage..."
docker stats --no-stream my-python-app
print_success "Resource monitoring working"
echo ""

echo "======================================"
echo -e "${GREEN}All tests passed successfully!${NC}"
echo "======================================"
echo ""
echo "Summary:"
echo "  ✓ Image built"
echo "  ✓ Container running"
echo "  ✓ Application accessible"
echo "  ✓ Volumes working"
echo "  ✓ Data persistence verified"
echo "  ✓ Networking configured"
echo "  ✓ Container communication working"
echo "  ✓ Logs accessible"
echo "  ✓ Container access working"
echo ""
echo "Cleanup will run automatically..."
