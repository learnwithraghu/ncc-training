# Topic 16: ConfigMaps (Env and File Based)

**Time:** 20 minutes

## Goal
Inject non-sensitive application configuration via ConfigMaps.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-16
kubectl apply -f assets/configmap-demo.yaml
kubectl get configmaps
kubectl describe configmap app-config
kubectl apply -f assets/pod-with-configmap-env.yaml
kubectl apply -f assets/pod-with-configmap-volume.yaml
kubectl exec pod/configmap-env-pod -- printenv | grep -i APP
kubectl delete -f assets/pod-with-configmap-env.yaml
kubectl delete -f assets/pod-with-configmap-volume.yaml
```

## Guided Steps
1. Create and inspect a ConfigMap.
2. Consume values as environment variables.
3. Mount values as files in a container.
4. Compare env and volume-based consumption patterns.

## Checkpoint
When would mounting ConfigMap data as files be better than environment variables?
