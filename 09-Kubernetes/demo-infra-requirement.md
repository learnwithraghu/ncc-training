# Demo Infra Requirement

## Infra Needed
- Kubernetes cluster access
- kubectl configured to the target cluster
- Permission to create namespace, pods, services, and deployments

## Quick Validation
```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
```
