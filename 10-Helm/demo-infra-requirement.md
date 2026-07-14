# Demo Infra Requirement

## Infra Needed
- Helm CLI installed
- Kubernetes cluster access through kubectl
- Network access to chart repositories

## Quick Validation
```bash
helm version
kubectl cluster-info
helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update
helm search repo bitnami/nginx | head -n 3
```
