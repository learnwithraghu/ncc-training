# Topic 7: Multi-Container Pods and Logs/Exec

**Time:** 20 minutes

## Goal
Operate multi-container pods and troubleshoot with logs and exec.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-07
kubectl apply -f assets/multi-container-pod.yaml
kubectl get pods
kubectl logs multi-container-pod -c nginx
kubectl logs multi-container-pod -c sidecar
kubectl exec -it multi-container-pod -c nginx -- sh
kubectl delete -f assets/multi-container-pod.yaml
```

## Guided Steps
1. Deploy a pod that contains multiple containers.
2. Pull logs from each container independently.
3. Exec into the main container and inspect files/processes.
4. Explain sidecar use cases.

## Checkpoint
Why do you need to specify a container name when reading logs in a multi-container pod?
