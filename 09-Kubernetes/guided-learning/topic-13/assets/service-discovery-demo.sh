#!/bin/bash

echo "========================================="
echo "Service Discovery Demonstration"
echo "========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Step 1: Creating deployment...${NC}"
kubectl create deployment web --image=nginx --replicas=3
kubectl wait --for=condition=available --timeout=60s deployment/web
echo ""

echo -e "${YELLOW}Step 2: Exposing as ClusterIP service...${NC}"
kubectl expose deployment web --port=80
kubectl get svc web
echo ""

echo -e "${YELLOW}Step 3: Testing DNS resolution...${NC}"
kubectl run dns-test --image=busybox --rm -it -- nslookup web
echo ""

echo -e "${YELLOW}Step 4: Testing HTTP access by service name...${NC}"
kubectl run http-test --image=busybox --rm -it -- wget -qO- http://web
echo ""

echo -e "${YELLOW}Cleaning up...${NC}"
kubectl delete deployment web
kubectl delete service web
echo ""

echo -e "${GREEN}✓ Service discovery demonstration complete!${NC}"
