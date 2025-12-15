#!/bin/bash
echo "Helm Demonstration"
echo "=================="
echo ""
echo "Adding Bitnami repository..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
echo ""
echo "Searching for nginx chart..."
helm search repo nginx
echo ""
echo "Demo complete! To install: helm install my-nginx bitnami/nginx"
