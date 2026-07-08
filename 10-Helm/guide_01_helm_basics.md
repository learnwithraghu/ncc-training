# Day 5, Guide 7: Helm Basics

## Goal
Understand Helm charts, releases, and values, and install a simple chart.

## Time
Approximately **45 minutes**.

## Prerequisites

- Helm installed (`helm version`)
- Kubernetes cluster access

---

## 1. What is Helm?

Helm is a package manager for Kubernetes. It helps you:

- Define applications as reusable charts
- Install and upgrade applications with one command
- Roll back to previous versions
- Share applications through chart repositories

## 2. Key Concepts

| Term | Meaning |
|------|---------|
| Chart | A package of Kubernetes manifests |
| Release | A running instance of a chart |
| Values | Configuration passed to a chart |
| Template | A manifest file with placeholders |

## 3. Common Helm Commands

```bash
# Search for charts
helm search hub nginx

# Add a repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install a chart
helm install my-nginx bitnami/nginx

# List releases
helm list

# Upgrade a release
helm upgrade my-nginx bitnami/nginx

# Uninstall a release
helm uninstall my-nginx
```

---

## Hands-On: Install Nginx with Helm

### Step 1: Add the Bitnami repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Step 2: Install Nginx

```bash
helm install my-nginx bitnami/nginx
```

### Step 3: Verify

```bash
helm list
kubectl get pods
kubectl get svc
```

### Step 4: Uninstall

```bash
helm uninstall my-nginx
```

---

## Check Your Understanding

1. What is the difference between a chart and a release?
2. Why would you use Helm instead of plain YAML manifests?
3. What command lists installed Helm releases?
4. How do you pass custom configuration to a Helm chart?

---

## Next Step

Continue to [guide_02_chart_for_capstone.md](guide_02_chart_for_capstone.md) to build a Helm chart for the document-search application.
