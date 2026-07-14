# Topic 12: NodePort and LoadBalancer Exposure Patterns

**Time:** 20 minutes

## Goal
Compare external access patterns using NodePort and LoadBalancer services.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-12
kubectl apply -f assets/nodeport-service.yaml
kubectl apply -f assets/loadbalancer-service.yaml
kubectl get svc -o wide
kubectl describe svc my-nodeport-service
kubectl describe svc my-loadbalancer-service
kubectl delete -f assets/nodeport-service.yaml
kubectl delete -f assets/loadbalancer-service.yaml
```

## Guided Steps
1. Apply NodePort and LoadBalancer definitions.
2. Compare how each service exposes traffic.
3. Review assigned ports and external IP behavior.
4. Discuss local cluster vs cloud behavior differences.

## Checkpoint
When would you choose NodePort over LoadBalancer in training environments?
