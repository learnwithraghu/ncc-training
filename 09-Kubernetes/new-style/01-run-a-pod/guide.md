# Topic 1: Run a Pod

**Time:** ~20 minutes

## What You'll Learn

1. Create a namespace and run one container as a Pod.
2. Reach that Pod from your laptop with `port-forward`.

## Goal

Get the Orbital Relay **1.0** day-shift page running on the cluster as a
single Pod. The image is already on Docker Hub:
`learnwithraghu/ncc-workshop:1.0`. You do not build or push anything.

## Commands

```bash
kubectl get nodes
kubectl create namespace orbital-relay
kubectl config set-context --current --namespace=orbital-relay
kubectl apply -f pod.yaml
kubectl get pods -o wide
kubectl port-forward pod/orbital-relay 18090:80
```

- `create namespace` / `set-context` — later topics stay in `orbital-relay`.
- `pod.yaml` — one container, image `learnwithraghu/ncc-workshop:1.0`.
- `port-forward` — tunnel Pod port 80 to your laptop on 18090 (not 8080; Docker often holds that).

## Guided Steps

1. Confirm the cluster:

```bash
kubectl get nodes
kubectl cluster-info
```

2. Create the namespace and make it the default:

```bash
kubectl create namespace orbital-relay
kubectl config set-context --current --namespace=orbital-relay
```

3. `cd` into this folder and apply the Pod:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/01-run-a-pod
kubectl apply -f pod.yaml
kubectl get pods -w
```

Wait until `STATUS` is `Running`, then Ctrl+C.

4. In one terminal: `kubectl port-forward pod/orbital-relay 18090:80`.
   In another: `curl -s http://localhost:18090 | grep -o "Ground link v1"`.
   Open `http://localhost:18090` — dark dashboard, **VERSION 1.0**.

## Task

`curl http://localhost:18090` shows **Ground link v1** from a Pod in the
`orbital-relay` namespace.

## Checkpoint

If you `kubectl delete pod orbital-relay` right now, does anything
recreate it? Why or why not?

## What's Next?

A bare Pod stays dead if you delete it. Next we put a Deployment in
front of it so Kubernetes replaces crashed Pods and we can scale.
**Topic 2: Deployment and Scaling.**
