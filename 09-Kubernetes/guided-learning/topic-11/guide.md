# Topic 11: Service Fundamentals (ClusterIP)

**Time:** 20 minutes

## Goal
Expose deployments internally using ClusterIP services and selectors.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-11
kubectl apply -f assets/nginx-deployment.yaml
kubectl expose deployment nginx-deployment --name=nginx-svc --port=80 --target-port=80
kubectl get svc nginx-svc
kubectl describe svc nginx-svc
kubectl get endpoints nginx-svc
kubectl delete svc nginx-svc
```

## Guided Steps
1. Expose an existing deployment as a ClusterIP service.
2. Inspect selector and endpoint mapping.
3. Verify that endpoints track deployment pods.
4. Clean up service resources.

## Checkpoint
Why do services use selectors and endpoints instead of fixed pod IPs?
