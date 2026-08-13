# Topic 5: Kubernetes Deployment

**Time:** ~20 minutes

## What You'll Learn

1. Create a dedicated namespace for Daypack.
2. Run the Hub image as a Deployment with probes and limits.
3. Confirm the Pod becomes Ready.

## Goal

Pull `learnwithraghu/ai-k8-workshop:1.0` on the cluster (no Docker build
on this host). Keys are already baked into the image.

## Commands

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl get pods -n daypack -w
kubectl describe pod -n daypack -l app=daypack
```

## Guided Steps

1. Confirm kubectl talks to your teaching cluster:

```bash
kubectl get nodes
cd ~/ncc-training/15-ai-k8-full-project/new-style/05-k8s-deployment
```

2. Apply namespace then Deployment:

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl get deploy,pods -n daypack
```

3. Wait until `READY` is `1/1` and `STATUS` is `Running`. If the image
   pull fails, confirm Hub has `learnwithraghu/ai-k8-workshop:1.0`
   (topic 04 / `build-and-push.sh`).

4. Optional: `kubectl logs -n daypack -l app=daypack --tail=30`

## Task

`kubectl get pods -n daypack` shows one Ready Pod. The Deployment image
is exactly `learnwithraghu/ai-k8-workshop:1.0` (no registry placeholder).

## Checkpoint

Why does this lab use `imagePullPolicy: Always` instead of baking a
local-only image with `Never`?

## What's Next?

Expose the Pod with a Service and open the UI via port-forward.
**Topic 6: Kubernetes Service.**
