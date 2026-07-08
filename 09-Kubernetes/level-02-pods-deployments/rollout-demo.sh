#!/bin/bash

# Kubernetes Rolling Update and Rollback Demonstration Script

echo "========================================="
echo "Rolling Update & Rollback Demonstration"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Create initial deployment
echo -e "${YELLOW}Step 1: Creating deployment with nginx:1.20...${NC}"
kubectl create deployment rollout-demo --image=nginx:1.20 --replicas=3
sleep 2
kubectl wait --for=condition=available --timeout=60s deployment/rollout-demo
kubectl get deployment rollout-demo
kubectl get pods -l app=rollout-demo
echo ""

# Update to nginx:1.21
echo -e "${YELLOW}Step 2: Rolling update to nginx:1.21...${NC}"
kubectl set image deployment/rollout-demo nginx=nginx:1.21
echo "Watching rollout status..."
kubectl rollout status deployment/rollout-demo
kubectl get deployment rollout-demo
kubectl get pods -l app=rollout-demo
echo ""

# Show rollout history
echo -e "${YELLOW}Step 3: Viewing rollout history...${NC}"
kubectl rollout history deployment/rollout-demo
echo ""

# Update to nginx:1.22
echo -e "${YELLOW}Step 4: Rolling update to nginx:1.22...${NC}"
kubectl set image deployment/rollout-demo nginx=nginx:1.22
kubectl rollout status deployment/rollout-demo
kubectl get deployment rollout-demo
echo ""

# Show updated history
echo -e "${YELLOW}Step 5: Updated rollout history...${NC}"
kubectl rollout history deployment/rollout-demo
echo ""

# Simulate bad deployment
echo -e "${RED}Step 6: Simulating bad deployment (broken image)...${NC}"
kubectl set image deployment/rollout-demo nginx=nginx:broken-image
sleep 5
kubectl get pods -l app=rollout-demo
echo ""
echo -e "${RED}Notice some pods in ImagePullBackOff state!${NC}"
echo ""

# Rollback
echo -e "${YELLOW}Step 7: Rolling back to previous version...${NC}"
kubectl rollout undo deployment/rollout-demo
kubectl rollout status deployment/rollout-demo
kubectl get deployment rollout-demo
kubectl get pods -l app=rollout-demo
echo ""

# Show final history
echo -e "${YELLOW}Step 8: Final rollout history...${NC}"
kubectl rollout history deployment/rollout-demo
echo ""

# Show ReplicaSets
echo -e "${YELLOW}Step 9: Viewing ReplicaSets (notice old ones are kept)...${NC}"
kubectl get replicaset -l app=rollout-demo
echo ""

# Cleanup
echo -e "${YELLOW}Cleaning up...${NC}"
kubectl delete deployment rollout-demo
echo ""

echo -e "${GREEN}✓ Rolling update and rollback demonstration complete!${NC}"
echo ""
echo "Key takeaways:"
echo "- Rolling updates happen gradually (zero downtime)"
echo "- Old ReplicaSets are kept for rollback"
echo "- Rollback is instant and safe"
echo "- Kubernetes tracks revision history"
echo "- Bad deployments can be quickly reverted"
