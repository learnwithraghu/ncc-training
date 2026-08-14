# Demo Infra Requirement

## Infra Needed

- Kubernetes cluster access
- kubectl configured to that cluster
- Cluster nodes able to pull public Docker Hub images
  (`learnwithraghu/ncc-workshop:1.0` and `:2.0`)
- Permission to create namespaces, pods, deployments, services,
  configmaps, secrets, and horizontalpodautoscalers
- metrics-server installed so `kubectl top nodes` and `kubectl top pods`
  work (required for Topic 8). Do not put a cluster-specific install
  into the student guide; kind, k3s, and EKS differ.
- No Ingress or storage class required

## Instructor laptop (before class only)

- Docker running
- Logged in to Docker Hub as `learnwithraghu`
- Run `bash 09-Kubernetes/new-style/helpers/build-and-push-images.sh`
- Confirm Hub has tags `1.0` and `2.0`

## Teaching host — clone and validate every command

No Docker on this machine. `kubectl` must already talk to the class
cluster.

```bash
git clone https://github.com/learnwithraghu/ncc-training.git
cd ncc-training
kubectl get nodes
bash 09-Kubernetes/new-style/helpers/command-helper.sh
```

Already cloned:

```bash
cd ~/ncc-training
git pull
bash 09-Kubernetes/new-style/helpers/command-helper.sh
```

Exit 0 means every topic command worked. Scratch namespace is
`orbital-relay-lab` (deleted at the end).

## Quick Validation

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
kubectl auth can-i create secrets
kubectl auth can-i create horizontalpodautoscalers.autoscaling
kubectl top nodes
bash 09-Kubernetes/new-style/helpers/command-helper.sh
```
