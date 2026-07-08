# Day 5, Guide 8: Helm Chart for the Document Search Capstone

## Goal
Create a Helm chart that deploys the document-search application to Kubernetes.

## Time
Approximately **60 minutes**.

## Prerequisites

- Completion of [guide_01_helm_basics.md](guide_01_helm_basics.md)
- The document-search Docker image available in your cluster

---

## 1. Chart Structure

A Helm chart has this structure:

```
document-search/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── _helpers.tpl
```

## 2. Create the Chart

```bash
cd ~/ncc-labs/day5
helm create document-search
```

This creates a starter chart. You will customize it for the document-search app.

## 3. Customize values.yaml

```yaml
replicaCount: 2

image:
  repository: document-search
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8501

config:
  appName: "Document Search"
  logLevel: "INFO"
```

## 4. Customize templates

Edit `templates/deployment.yaml` to use the values:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "document-search.fullname" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "document-search.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "document-search.name" . }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
          env:
            - name: APP_NAME
              value: {{ .Values.config.appName | quote }}
            - name: LOG_LEVEL
              value: {{ .Values.config.logLevel | quote }}
```

## 5. Install the Chart

```bash
helm install doc-search ./document-search
```

## 6. Verify

```bash
helm list
kubectl get pods
kubectl get svc
```

---

## Day 5 Completion Checklist

By the end of this guide, you should have:

- [ ] A Helm chart for the document-search app
- [ ] The app deployed to Kubernetes
- [ ] Ability to upgrade and rollback the release

Next, complete the [Capstone](../11-Capstone-Document-Search/README.md) end-to-end walkthrough.

---

## Check Your Understanding

1. What files are required in a Helm chart?
2. How do you reference a value in a template?
3. What is the purpose of `_helpers.tpl`?
4. How do you upgrade a Helm release with new values?
