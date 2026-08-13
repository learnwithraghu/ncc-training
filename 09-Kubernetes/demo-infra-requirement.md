# Demo Infra Requirement

## Infra Needed

- Kubernetes cluster access
- kubectl configured to that cluster
- Cluster nodes able to pull public Docker Hub images
  (`learnwithraghu/ncc-workshop:1.0` and `:2.0`)
- Permission to create namespaces, pods, deployments, services,
  configmaps, and secrets
- No Ingress, storage class, or metrics-server required

## Instructor laptop (before class only)

- Docker running
- Logged in to Docker Hub as `learnwithraghu`
- Run `bash 09-Kubernetes/new-style/helpers/build-and-push-images.sh`
- Confirm Hub has tags `1.0` and `2.0`

## Quick Validation

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
kubectl auth can-i create secrets
```

After the instructor script has pushed:

```bash
docker pull learnwithraghu/ncc-workshop:1.0
docker pull learnwithraghu/ncc-workshop:2.0
```
