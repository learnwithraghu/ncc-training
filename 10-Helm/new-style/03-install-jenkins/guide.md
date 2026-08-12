# Topic 3: Install Jenkins (Signal Forge)

**Time:** ~25 minutes

## What You'll Learn (and Solve)

1. Install the official `jenkins/jenkins` chart as release `signal-forge`.
2. Pass a small `values-lab.yaml` instead of accepting every chart default.
3. Wait until the Jenkins controller Pod is Ready.
4. Confirm Service / Pod objects exist via kubectl.
5. Solve "I need Jenkins on the cluster without writing 20 YAML files by hand."

## Goal
Install **Signal Forge** — Jenkins from the open-source chart — into namespace
`signal-forge` using lab values.

Work in this folder. It has `values-lab.yaml`.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/03-install-jenkins
kubectl create namespace signal-forge --dry-run=client -o yaml | kubectl apply -f -
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
kubectl get pods,svc -n signal-forge
kubectl rollout status statefulset/signal-forge-jenkins -n signal-forge
```

- `helm install <release> <chart> -f values` — creates a release from a chart.
- Lab values turn on `NodePort` `32080`, set admin to `admin` / `Passw0rd`, and
  disable persistence so teardown is easy.
- The Jenkins chart typically creates a StatefulSet named
  `<release>-jenkins`.

## Guided Steps

1. Open this folder and read the lab values:

```bash
cd ~/ncc-training/10-Helm/new-style/03-install-jenkins
cat values-lab.yaml
```

2. Ensure the namespace and repo exist (safe to re-run):

```bash
kubectl create namespace signal-forge --dry-run=client -o yaml | kubectl apply -f -
helm repo add jenkins https://charts.jenkins.io 2>/dev/null || true
helm repo update
```

3. Install the release:

```bash
helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
```

4. Wait for Jenkins to become Ready (first start can take several minutes while
   plugins initialize):

```bash
kubectl get pods -n signal-forge -w
# Ctrl+C when the controller shows 2/2 or Running/Ready
kubectl get svc -n signal-forge
```

5. Note the Service NodePort — lab values request **32080**.

Leave the release installed for later topics.

## Task

Install `signal-forge` with `values-lab.yaml` and show the instructor a Ready
Jenkins Pod plus a Service in namespace `signal-forge`.

## Checkpoint

Why pass `-f values-lab.yaml` instead of installing with zero overrides?

## What's Next?
This is good, but we still need:

1. Helm commands that describe the release, not only kubectl.
2. The rendered values Helm actually used.
3. The full manifest set the chart produced.
4. A browser path into the Jenkins UI.
5. Release inspection — **Topic 4: Inspect the Release**.
