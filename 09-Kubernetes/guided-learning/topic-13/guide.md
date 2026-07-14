# Topic 13: DNS and Service Discovery

**Time:** 20 minutes

## Goal
Validate in-cluster name resolution and service discovery behavior.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-13
kubectl apply -f assets/clusterip-service.yaml
kubectl run dns-test --image=busybox:1.35 --restart=Never -it --rm -- nslookup my-clusterip-service
kubectl get svc
bash assets/service-discovery-demo.sh
kubectl delete -f assets/clusterip-service.yaml
```

## Guided Steps
1. Create a ClusterIP service used for DNS testing.
2. Run temporary busybox pod to query service DNS.
3. Review service-discovery demo script output.
4. Connect DNS naming with stable service endpoints.

## Checkpoint
What is the main benefit of addressing services by DNS name in Kubernetes?
