# Day 5, Capstone Guide 6: Deploy with Helm

## Goal
Package the Kubernetes manifests into a Helm chart and deploy the application.

## Time
Approximately **20 minutes**.

## Prerequisites

- Helm installed
- Kubernetes cluster running
- Completion of [guide_05_k8s_deploy.md](guide_05_k8s_deploy.md)

---

## Step 1: Create the Chart

```bash
cd ~/ncc-labs/day5
helm create document-search-chart
```

## Step 2: Customize values.yaml

Edit `document-search-chart/values.yaml`:

```yaml
replicaCount: 2

image:
  repository: document-search
  tag: latest
  pullPolicy: Never

service:
  type: NodePort
  port: 5000

config:
  appEnv: "helm"
```

## Step 3: Customize Templates

Edit `document-search-chart/templates/deployment.yaml` to include the ConfigMap reference:

```yaml
envFrom:
  - configMapRef:
      name: {{ include "document-search-chart.fullname" . }}-config
```

Create `document-search-chart/templates/configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "document-search-chart.fullname" . }}-config
data:
  APP_ENV: {{ .Values.config.appEnv | quote }}
```

## Step 4: Install the Chart

```bash
helm install doc-search ./document-search-chart
```

## Step 5: Verify

```bash
helm list
kubectl get pods
kubectl get svc
```

## Step 6: Upgrade

Change `replicaCount` to 3 in `values.yaml`, then:

```bash
helm upgrade doc-search ./document-search-chart
```

---

## Check Your Understanding

1. What is the advantage of using Helm over plain manifests?
2. How do you upgrade a Helm release?
3. Where are chart values defined?
