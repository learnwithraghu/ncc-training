# Topic 15: Network Policies and Connectivity Controls

**Time:** 20 minutes

## Goal
Apply network policy basics to control pod-to-pod communication.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-15
kubectl apply -f assets/network-policy.yaml
kubectl get networkpolicies
kubectl describe networkpolicy backend-policy
kubectl get pods -o wide
kubectl delete -f assets/network-policy.yaml
```

## Guided Steps
1. Apply a network policy example.
2. Inspect policy selectors and ingress/egress rules.
3. Discuss default allow vs restricted behavior.
4. Explain CNI support requirement for enforcement.

## Checkpoint
What two selectors must align for a network policy rule to apply correctly?
