#!/bin/bash
echo "Storage and Configuration Demo"
echo "==============================="
echo ""
echo "Creating ConfigMap..."
kubectl create configmap demo-config --from-literal=key1=value1
kubectl get cm demo-config
echo ""
echo "Creating Secret..."
kubectl create secret generic demo-secret --from-literal=password=secret123
kubectl get secret demo-secret
echo ""
echo "Cleaning up..."
kubectl delete cm demo-config
kubectl delete secret demo-secret
echo "Demo complete!"
