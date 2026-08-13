# Topic 6: Kubernetes Service

**Time:** ~20 minutes

## What You'll Learn

1. Give the Deployment a stable ClusterIP Service.
2. Reach Daypack with `kubectl port-forward` (no Ingress in this lab).
3. Open the Streamlit UI in a browser.

## Goal

Browse Daypack at `http://localhost:8501` through the Service.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc,endpoints -n daypack
kubectl port-forward svc/daypack 8501:8501 -n daypack
```

## Guided Steps

1. Apply from this folder (safe to re-apply the Deployment):

```bash
cd ~/ncc-training/15-ai-k8-full-project/new-style/06-k8s-service
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc,endpoints -n daypack
```

2. Confirm endpoints list a Pod IP on port 8501.

3. Forward the Service to your laptop and leave the command running:

```bash
kubectl port-forward svc/daypack 8501:8501 -n daypack
```

4. Open `http://localhost:8501`. Plan a short trip. Stop the forward
   with Ctrl+C when finished.

Instructor one-shot (applies 05 + 06, checks health, prints the same
port-forward command):

```bash
bash ~/ncc-training/15-ai-k8-full-project/new-style/helpers/deploy-k8s.sh
```

## Task

`kubectl get endpoints daypack -n daypack` shows one address, and the
browser loads Daypack through the port-forward.

## Checkpoint

Why port-forward to `svc/daypack` instead of a raw Pod name?

## What's Next?

You finished the end-to-end path: local app → Docker image → Hub →
Deployment → Service → UI. Re-run the two helper scripts whenever you
change the app or need a clean cluster deploy.
