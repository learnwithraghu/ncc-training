#!/bin/bash

# Kubernetes Cluster Verification Script
# This script checks if your Kubernetes cluster is healthy and ready

echo "========================================="
echo "Kubernetes Cluster Health Check"
echo "========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: kubectl installation
echo "1. Checking kubectl installation..."
if command -v kubectl &> /dev/null; then
    KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -n 1)
    echo -e "${GREEN}✓${NC} kubectl is installed: $KUBECTL_VERSION"
else
    echo -e "${RED}✗${NC} kubectl is not installed"
    echo "   Please install kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi
echo ""

# Check 2: Cluster connectivity
echo "2. Checking cluster connectivity..."
if kubectl cluster-info &> /dev/null; then
    echo -e "${GREEN}✓${NC} Successfully connected to cluster"
    kubectl cluster-info | head -n 2
else
    echo -e "${RED}✗${NC} Cannot connect to cluster"
    echo "   Check if your cluster is running and kubeconfig is correct"
    exit 1
fi
echo ""

# Check 3: Node status
echo "3. Checking node status..."
NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)
READY_NODES=$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready")

if [ "$NODE_COUNT" -eq 0 ]; then
    echo -e "${RED}✗${NC} No nodes found in cluster"
    exit 1
elif [ "$NODE_COUNT" -eq "$READY_NODES" ]; then
    echo -e "${GREEN}✓${NC} All $NODE_COUNT node(s) are Ready"
    kubectl get nodes
else
    echo -e "${YELLOW}⚠${NC} $READY_NODES out of $NODE_COUNT nodes are Ready"
    kubectl get nodes
fi
echo ""

# Check 4: System pods
echo "4. Checking system pods in kube-system namespace..."
TOTAL_PODS=$(kubectl get pods -n kube-system --no-headers 2>/dev/null | wc -l)
RUNNING_PODS=$(kubectl get pods -n kube-system --no-headers 2>/dev/null | grep -c "Running")

if [ "$TOTAL_PODS" -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No system pods found"
elif [ "$TOTAL_PODS" -eq "$RUNNING_PODS" ]; then
    echo -e "${GREEN}✓${NC} All $TOTAL_PODS system pods are Running"
else
    echo -e "${YELLOW}⚠${NC} $RUNNING_PODS out of $TOTAL_PODS system pods are Running"
    echo "   Non-running pods:"
    kubectl get pods -n kube-system --no-headers | grep -v "Running"
fi
echo ""

# Check 5: API server responsiveness
echo "5. Checking API server responsiveness..."
START_TIME=$(date +%s%N)
kubectl get namespaces &> /dev/null
END_TIME=$(date +%s%N)
RESPONSE_TIME=$(( (END_TIME - START_TIME) / 1000000 ))

if [ "$RESPONSE_TIME" -lt 1000 ]; then
    echo -e "${GREEN}✓${NC} API server is responsive (${RESPONSE_TIME}ms)"
elif [ "$RESPONSE_TIME" -lt 3000 ]; then
    echo -e "${YELLOW}⚠${NC} API server is slow (${RESPONSE_TIME}ms)"
else
    echo -e "${RED}✗${NC} API server is very slow (${RESPONSE_TIME}ms)"
fi
echo ""

# Check 6: Namespaces
echo "6. Checking namespaces..."
NAMESPACE_COUNT=$(kubectl get namespaces --no-headers 2>/dev/null | wc -l)
echo -e "${GREEN}✓${NC} Found $NAMESPACE_COUNT namespace(s)"
kubectl get namespaces
echo ""

# Check 7: Current context
echo "7. Checking current context..."
CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null)
if [ -n "$CURRENT_CONTEXT" ]; then
    echo -e "${GREEN}✓${NC} Current context: $CURRENT_CONTEXT"
    
    # Get current namespace
    CURRENT_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -z "$CURRENT_NS" ]; then
        CURRENT_NS="default"
    fi
    echo "   Default namespace: $CURRENT_NS"
else
    echo -e "${RED}✗${NC} No context set"
fi
echo ""

# Summary
echo "========================================="
echo "Summary"
echo "========================================="
echo "Cluster: $CURRENT_CONTEXT"
echo "Nodes: $READY_NODES/$NODE_COUNT Ready"
echo "System Pods: $RUNNING_PODS/$TOTAL_PODS Running"
echo "Namespaces: $NAMESPACE_COUNT"
echo "API Response Time: ${RESPONSE_TIME}ms"
echo ""

# Overall status
if [ "$NODE_COUNT" -eq "$READY_NODES" ] && [ "$TOTAL_PODS" -eq "$RUNNING_PODS" ] && [ "$RESPONSE_TIME" -lt 2000 ]; then
    echo -e "${GREEN}✓ Cluster is healthy and ready!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠ Cluster has some issues but is operational${NC}"
    exit 0
fi
