# Demo Infra Requirement

## Infra Needed

- Kubernetes cluster access
- kubectl configured to the target cluster
- Permission to create namespaces, pods, deployments, services,
  configmaps, and secrets
- No Ingress controller, storage class, or metrics-server required for the
  core topics; `kubectl top` in Topic 8 is optional and needs
  metrics-server if you want to demo it

## Quick Validation

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
kubectl auth can-i create secrets
```

## Instructor Lab Runner

```bash
cd ~/ncc-training/09-Kubernetes/new-style/helpers
bash run-k8s-lab.sh
```

It applies every topic's manifests into a scratch namespace
(`orbital-relay-lab`), waits for each rollout, curls Orbital Relay through
a port-forward, exercises the rollback (topic 5) and probe-failure
(topic 8) scenarios, then deletes the namespace. Exit code 0 means the lab
is ready to teach.
