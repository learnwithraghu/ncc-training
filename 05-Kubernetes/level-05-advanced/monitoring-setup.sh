#!/bin/bash
echo "Monitoring Setup"
echo "================"
echo ""
echo "Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
echo ""
echo "Waiting for metrics-server to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/metrics-server -n kube-system
echo ""
echo "Checking node metrics..."
kubectl top nodes
echo ""
echo "Checking pod metrics..."
kubectl top pods -A
echo ""
echo "Monitoring setup complete!"
