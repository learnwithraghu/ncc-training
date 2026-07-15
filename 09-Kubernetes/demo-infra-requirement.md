# Demo Infra Requirement

## Infra Needed
- Kubernetes cluster access
- kubectl configured to the target cluster
- Permission to create namespace, pods, services, deployments, and other workload resources

## Quick Validation
```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
```

## Full Validation
Run the module validator before teaching or running the guided topics. It exercises the entire Kubernetes curriculum end-to-end and cleans up after itself.

```bash
/workspaces/ncc-training/09-Kubernetes/helpers/validate-infra.sh
```
