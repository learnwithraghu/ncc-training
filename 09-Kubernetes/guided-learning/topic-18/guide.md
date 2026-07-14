# Topic 18: Volumes, PV, and PVC Workflows

**Time:** 20 minutes

## Goal
Use persistent storage primitives for stateful workloads.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-18
kubectl apply -f assets/pv-example.yaml
kubectl apply -f assets/pvc-example.yaml
kubectl get pv
kubectl get pvc
kubectl apply -f assets/pod-with-pvc.yaml
kubectl get pods
bash assets/storage-demo.sh
```

## Guided Steps
1. Create persistent volume and claim resources.
2. Confirm claim binding status.
3. Run a pod that mounts the PVC.
4. Use the storage demo script to validate behavior.

## Checkpoint
What does a PVC abstract away from application teams?
