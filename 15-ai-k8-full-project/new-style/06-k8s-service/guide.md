# Topic 6: Kubernetes Service

**Time:** ~20 minutes

## What You'll Learn

1. Give the Deployment a stable ClusterIP Service.
2. Reach Daypack with `kubectl port-forward` (no Ingress in this lab).
3. Open the Streamlit UI in a browser.

## Goal

Browse Daypack through the Service: laptop `http://localhost:8501`, or
remote teaching host **View Port 8501**.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc,endpoints -n daypack
kubectl port-forward --address 0.0.0.0 svc/daypack 8501:8501 -n daypack
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

3. Forward the Service on the machine that has `kubectl` (laptop or
   teaching host) and leave the command running. `--address 0.0.0.0`
   lets a remote lab proxy reach the tunnel; on a laptop,
   `http://localhost:8501` still works.

```bash
kubectl port-forward --address 0.0.0.0 svc/daypack 8501:8501 -n daypack
```

4. Open the UI, plan a short trip, then stop the forward with Ctrl+C:
   - Laptop: `http://localhost:8501`
   - Remote teaching host (KodeKloud student-node): **View Port 8501**,
     not 80. Host port 80 is Ubuntu nginx, not Daypack. A `502` from
     `nginx/1.27.x` means the lab proxy reached the jump host but
     nothing was listening on 8501 — usually the forward is missing or
     bound to `127.0.0.1` only.

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
