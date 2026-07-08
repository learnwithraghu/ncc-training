# Day 5, Capstone Guide 5: Deploy to Kubernetes

## Goal
Deploy the document-search application to Kubernetes using plain manifests.

## Time
Approximately **20 minutes**.

## Prerequisites

- Kubernetes cluster running
- `kubectl` configured
- Docker image `document-search:latest` built

---

## Step 1: Create Manifests Directory

```bash
mkdir -p ~/ncc-labs/day5/document-search/k8s
cd ~/ncc-labs/day5/document-search/k8s
```

## Step 2: Create ConfigMap

```bash
cat > configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: document-search-config
data:
  APP_ENV: "kubernetes"
EOF
```

## Step 3: Create Deployment

```bash
cat > deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: document-search
spec:
  replicas: 2
  selector:
    matchLabels:
      app: document-search
  template:
    metadata:
      labels:
        app: document-search
    spec:
      containers:
        - name: document-search
          image: document-search:latest
          imagePullPolicy: Never
          ports:
            - containerPort: 5000
          envFrom:
            - configMapRef:
                name: document-search-config
EOF
```

> **Note:** `imagePullPolicy: Never` tells Kubernetes to use the locally built image. For clusters that cannot access local images, use `kind load` or `minikube image load`.

## Step 4: Create Service

```bash
cat > service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: document-search
spec:
  selector:
    app: document-search
  ports:
    - port: 5000
      targetPort: 5000
  type: NodePort
EOF
```

## Step 5: Apply Manifests

```bash
kubectl apply -f .
```

## Step 6: Verify

```bash
kubectl get pods
kubectl get svc
kubectl port-forward svc/document-search 5000:5000
```

In another terminal:

```bash
curl http://localhost:5000/
```

---

## Check Your Understanding

1. Why do we use `imagePullPolicy: Never`?
2. What does the Service do?
3. How would you scale the Deployment to 3 replicas?
