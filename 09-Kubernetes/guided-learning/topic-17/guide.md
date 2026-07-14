# Topic 17: Secrets and Secure Configuration Patterns

**Time:** 20 minutes

## Goal
Manage sensitive settings with Secrets and safe consumption patterns.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-17
kubectl apply -f assets/secret-demo.yaml
kubectl get secrets
kubectl describe secret db-secret
kubectl apply -f assets/pod-with-secret-env.yaml
kubectl apply -f assets/pod-with-secret-volume.yaml
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 --decode && echo
kubectl delete -f assets/pod-with-secret-env.yaml
kubectl delete -f assets/pod-with-secret-volume.yaml
```

## Guided Steps
1. Create and inspect a Secret object.
2. Use secrets as environment variables and mounted files.
3. Decode one value to understand storage representation.
4. Discuss secret handling and access control best practices.

## Checkpoint
Why should secret values still be protected even though they are base64 encoded?
