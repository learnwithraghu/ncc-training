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

## Full Validation
Run the module validator before teaching or running the guided topics. It exercises the entire Helm curriculum end-to-end and cleans up after itself.

```bash
/workspaces/ncc-training/10-Helm/helpers/validate-infra.sh
```
