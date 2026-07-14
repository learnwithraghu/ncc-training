# Topic 4: Namespaces and Context Management

**Time:** 20 minutes

## Goal
Create logical environment boundaries using namespaces and manage current context safely.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-04
kubectl get ns
kubectl create namespace dev
kubectl apply -f assets/namespace-demo.yaml
kubectl config set-context --current --namespace=dev
kubectl get pods
kubectl config set-context --current --namespace=default
kubectl delete namespace dev demo-namespace
```

## Guided Steps
1. Review existing namespaces and create a dev namespace.
2. Apply a namespace manifest and compare imperative vs declarative creation.
3. Switch default namespace in your current context.
4. Switch back to default and clean up.

## Checkpoint
Why is setting the current namespace useful in day-to-day kubectl usage?
