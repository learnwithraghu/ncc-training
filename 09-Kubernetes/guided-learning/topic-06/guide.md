# Topic 6: Declarative YAML Fundamentals

**Time:** 20 minutes

## Goal
Adopt declarative workflows using manifests and apply/delete patterns.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-06
cat assets/simple-pod.yaml
kubectl apply -f assets/simple-pod.yaml
kubectl get pod nginx-pod -o yaml
kubectl delete -f assets/simple-pod.yaml
```

## Guided Steps
1. Read the basic manifest structure: apiVersion, kind, metadata, spec.
2. Apply the manifest and verify the object exists.
3. Export live YAML to compare desired and current state.
4. Delete using the same declarative file.

## Checkpoint
Why is apply with version-controlled YAML preferred in team workflows?
