# Topic 14: Ingress Basics and Traffic Routing

**Time:** 20 minutes

## Goal
Understand HTTP routing with Ingress resources and host/path rules.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-14
kubectl apply -f assets/ingress-example.yaml
kubectl get ingress
kubectl describe ingress my-ingress
kubectl get svc
kubectl delete -f assets/ingress-example.yaml
```

## Guided Steps
1. Apply an ingress manifest.
2. Inspect host and path routing rules.
3. Check backend service mapping.
4. Discuss ingress-controller dependency for actual traffic handling.

## Checkpoint
Why does creating an Ingress resource alone not guarantee external access?
