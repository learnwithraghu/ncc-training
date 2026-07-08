#!/bin/bash

# Kubernetes Scaling Demonstration Script

echo "========================================="
echo "Kubernetes Scaling Demonstration"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create deployment
echo -e "${YELLOW}Step 1: Creating deployment with 2 replicas...${NC}"
kubectl create deployment scale-demo --image=nginx:1.21 --replicas=2
sleep 2
kubectl get deployment scale-demo
echo ""

# Wait for pods to be ready
echo -e "${YELLOW}Waiting for pods to be ready...${NC}"
kubectl wait --for=condition=available --timeout=60s deployment/scale-demo
kubectl get pods -l app=scale-demo
echo ""

# Scale up
echo -e "${YELLOW}Step 2: Scaling up to 5 replicas...${NC}"
kubectl scale deployment scale-demo --replicas=5
sleep 3
kubectl get deployment scale-demo
kubectl get pods -l app=scale-demo
echo ""

# Scale down
echo -e "${YELLOW}Step 3: Scaling down to 3 replicas...${NC}"
kubectl scale deployment scale-demo --replicas=3
sleep 3
kubectl get deployment scale-demo
kubectl get pods -l app=scale-demo
echo ""

# Show ReplicaSet
echo -e "${YELLOW}Step 4: Viewing ReplicaSet (manages pods)...${NC}"
kubectl get replicaset -l app=scale-demo
echo ""

# Show hierarchy
echo -e "${YELLOW}Step 5: Showing Deployment → ReplicaSet → Pods hierarchy...${NC}"
kubectl get deploy,rs,pods -l app=scale-demo
echo ""

# Cleanup
echo -e "${YELLOW}Cleaning up...${NC}"
kubectl delete deployment scale-demo
echo ""

echo -e "${GREEN}✓ Scaling demonstration complete!${NC}"
echo ""
echo "Key takeaways:"
echo "- Deployments manage ReplicaSets"
echo "- ReplicaSets manage Pods"
echo "- Scaling is instant and automatic"
echo "- Kubernetes maintains desired state"
