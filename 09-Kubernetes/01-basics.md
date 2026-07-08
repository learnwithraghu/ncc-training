# Level 1: Kubernetes Basics

**Master the fundamentals of Kubernetes cluster interaction**

## Learning Objectives

By the end of this level, you will:

- ✅ Verify your Kubernetes cluster is running properly
- ✅ Understand and use kubectl effectively
- ✅ Navigate Kubernetes namespaces
- ✅ Explore cluster resources and components
- ✅ Manage kubectl contexts and configurations
- ✅ Use kubectl help and documentation features

**Estimated Time:** 45 minutes

---

## Prerequisites

Before starting, ensure:
- Kubernetes cluster is running (Minikube, Kind, or cloud-based)
- kubectl is installed and configured
- You can access the cluster

---

## 1. Cluster Verification

### Check kubectl Installation

First, verify kubectl is installed:

```bash
kubectl version --client
```

**Expected output:**
```
Client Version: v1.28.x
Kustomize Version: v5.0.x
```

### Verify Cluster Connection

Check if you can connect to your cluster:

```bash
kubectl cluster-info
```

**Expected output:**
```
Kubernetes control plane is running at https://...
CoreDNS is running at https://...
```

If you see errors, your cluster might not be running or kubectl isn't configured correctly.

### View Cluster Nodes

See all nodes in your cluster:

```bash
kubectl get nodes
```

**Expected output:**
```
NAME           STATUS   ROLES           AGE   VERSION
minikube       Ready    control-plane   5d    v1.28.3
```

For more detailed information:

```bash
kubectl get nodes -o wide
```

This shows additional columns: internal IP, external IP, OS, kernel version, container runtime.

### Describe a Node

Get detailed information about a specific node:

```bash
kubectl describe node <node-name>
```

Replace `<node-name>` with your node's name from the previous command.

**What to look for:**
- **Conditions**: Is the node ready? Any disk/memory pressure?
- **Capacity**: Total CPU and memory
- **Allocatable**: Resources available for pods
- **System Info**: OS, kernel, container runtime
- **Pods**: Which pods are running on this node

---

## 2. Understanding Namespaces

### What are Namespaces?

Namespaces provide a way to divide cluster resources between multiple users or teams. Think of them as virtual clusters within your physical cluster.

### List All Namespaces

```bash
kubectl get namespaces
# or short form
kubectl get ns
```

**Expected output:**
```
NAME              STATUS   AGE
default           Active   5d
kube-node-lease   Active   5d
kube-public       Active   5d
kube-system       Active   5d
```

**Default namespaces:**
- **default**: Where resources go if you don't specify a namespace
- **kube-system**: Kubernetes system components (DNS, dashboard, etc.)
- **kube-public**: Publicly readable, mostly for cluster information
- **kube-node-lease**: Node heartbeat data (for node health)

### Create a Namespace

Create a namespace for development:

```bash
kubectl create namespace dev
```

Verify it was created:

```bash
kubectl get ns dev
```

### Create Namespace from YAML

You can also create namespaces declaratively:

```bash
kubectl apply -f level-01-basics/namespace-demo.yaml
```

View the YAML file to see the structure:

```bash
cat level-01-basics/namespace-demo.yaml
```

### Delete a Namespace

**⚠️ Warning:** Deleting a namespace deletes ALL resources in it!

```bash
kubectl delete namespace dev
```

---

## 3. Exploring Cluster Resources

### View All Resources

See all resources in the default namespace:

```bash
kubectl get all
```

See all resources across all namespaces:

```bash
kubectl get all --all-namespaces
# or short form
kubectl get all -A
```

### View Specific Resource Types

```bash
# Pods
kubectl get pods
kubectl get pods -A

# Services
kubectl get services
kubectl get svc -A

# Deployments
kubectl get deployments
kubectl get deploy -A

# ReplicaSets
kubectl get replicasets
kubectl get rs -A

# ConfigMaps
kubectl get configmaps
kubectl get cm -A

# Secrets
kubectl get secrets -A
```

### View Resources in Specific Namespace

```bash
kubectl get pods -n kube-system
kubectl get all -n kube-system
```

The `-n` flag specifies the namespace.

### Output Formats

kubectl supports various output formats:

**Wide output** (more columns):
```bash
kubectl get pods -o wide
```

**YAML format**:
```bash
kubectl get pods -o yaml
```

**JSON format**:
```bash
kubectl get pods -o json
```

**Custom columns**:
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
```

**JSONPath** (extract specific fields):
```bash
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
```

---

## 4. kubectl Explain - Built-in Documentation

One of kubectl's most powerful features is built-in documentation.

### Explain Resources

Learn about any Kubernetes resource:

```bash
kubectl explain pod
```

This shows the structure and fields of a Pod resource.

### Drill Down into Fields

```bash
kubectl explain pod.spec
kubectl explain pod.spec.containers
kubectl explain pod.spec.containers.image
```

Each level shows more detail about that specific field.

### Practical Example

Want to know what fields a Deployment has?

```bash
kubectl explain deployment
kubectl explain deployment.spec
kubectl explain deployment.spec.replicas
kubectl explain deployment.spec.template
```

**💡 Tip:** Use `kubectl explain` whenever you're writing YAML and forget a field name or structure!

---

## 5. kubectl Context Management

### What is a Context?

A context is a group of access parameters:
- **Cluster**: Which Kubernetes cluster
- **User**: Which credentials to use
- **Namespace**: Default namespace for commands

### View Current Context

```bash
kubectl config current-context
```

### List All Contexts

```bash
kubectl config get-contexts
```

**Output shows:**
- `*` indicates current context
- CLUSTER, AUTHINFO, NAMESPACE columns

### Switch Context

If you have multiple clusters:

```bash
kubectl config use-context <context-name>
```

### Set Default Namespace

Instead of using `-n namespace` every time:

```bash
kubectl config set-context --current --namespace=dev
```

Now all commands default to the `dev` namespace.

To switch back to default:

```bash
kubectl config set-context --current --namespace=default
```

### View Full Configuration

```bash
kubectl config view
```

This shows clusters, users, and contexts defined in your kubeconfig file.

---

## 6. Describing and Inspecting Resources

### Describe Command

The `describe` command shows detailed information about resources:

```bash
kubectl describe node <node-name>
kubectl describe namespace default
```

**What describe shows:**
- Resource metadata (name, labels, annotations)
- Spec (desired state)
- Status (current state)
- Events (recent activities)

### Get vs Describe

**`kubectl get`:**
- Quick overview
- List multiple resources
- Structured output (table, YAML, JSON)

**`kubectl describe`:**
- Detailed information
- Human-readable format
- Includes events
- One resource at a time

---

## 7. Cluster Component Status

### Check Component Health

```bash
kubectl get componentstatuses
# or short form
kubectl get cs
```

**Note:** This command is deprecated in newer Kubernetes versions but still useful in older clusters.

### View System Pods

Kubernetes system components run as pods in the `kube-system` namespace:

```bash
kubectl get pods -n kube-system
```

**Common system pods:**
- `coredns-*`: DNS server
- `etcd-*`: Key-value store
- `kube-apiserver-*`: API server
- `kube-controller-manager-*`: Controller manager
- `kube-proxy-*`: Network proxy
- `kube-scheduler-*`: Scheduler

### Check Pod Status

```bash
kubectl get pods -n kube-system -o wide
```

All system pods should be in `Running` status.

---

## 8. API Resources

### List All API Resources

```bash
kubectl api-resources
```

This shows all resource types available in your cluster:
- NAME: Resource name (plural)
- SHORTNAMES: Abbreviations (e.g., `po` for pods)
- APIVERSION: API group and version
- NAMESPACED: Whether resource is namespaced
- KIND: Resource type in YAML

**Useful for:**
- Finding short names (`po`, `svc`, `deploy`)
- Checking if a resource is namespaced
- Discovering available resources

### List API Versions

```bash
kubectl api-versions
```

Shows all API versions supported by your cluster.

---

## 9. Cluster Information Dump

### Generate Cluster Diagnostic Info

For troubleshooting, generate a complete cluster dump:

```bash
kubectl cluster-info dump
```

**⚠️ Warning:** This produces a LOT of output!

Save to a file:

```bash
kubectl cluster-info dump > cluster-dump.txt
```

Or dump specific namespace:

```bash
kubectl cluster-info dump --namespaces kube-system > kube-system-dump.txt
```

---

## 10. kubectl Cheat Sheet

### Quick Reference

```bash
# Cluster info
kubectl cluster-info
kubectl get nodes
kubectl get componentstatuses

# Namespaces
kubectl get namespaces
kubectl create namespace <name>
kubectl delete namespace <name>

# Resources
kubectl get all
kubectl get all -A
kubectl get <resource>
kubectl get <resource> -n <namespace>

# Describe
kubectl describe <resource> <name>
kubectl describe <resource> <name> -n <namespace>

# Output formats
kubectl get <resource> -o wide
kubectl get <resource> -o yaml
kubectl get <resource> -o json

# Documentation
kubectl explain <resource>
kubectl explain <resource>.<field>

# Context
kubectl config current-context
kubectl config get-contexts
kubectl config use-context <context>
kubectl config set-context --current --namespace=<namespace>

# API
kubectl api-resources
kubectl api-versions
```

See `level-01-basics/kubectl-cheatsheet.md` for a comprehensive reference.

---

## Hands-On Practice

### Exercise 1: Cluster Exploration

1. Check your cluster info and nodes
2. List all namespaces
3. View all pods in kube-system namespace
4. Describe one of the system pods
5. Check what resources are available in your cluster

### Exercise 2: Namespace Management

1. Create a namespace called `test`
2. Create another namespace called `production`
3. List all namespaces
4. Set your default namespace to `test`
5. Verify the change
6. Switch back to `default` namespace
7. Delete the `test` namespace

### Exercise 3: kubectl Exploration

1. Use `kubectl explain` to learn about Deployments
2. Find the short name for `services`
3. View all API versions
4. Get all resources in YAML format
5. Use JSONPath to extract just pod names

### Exercise 4: Cluster Health Check

Run the cluster verification script:

```bash
bash level-01-basics/verify-cluster.sh
```

This script checks:
- kubectl installation
- Cluster connectivity
- Node status
- System pod health
- API server responsiveness

---

## Common Issues and Solutions

### Issue: "The connection to the server was refused"

**Cause:** Cluster is not running or kubectl is misconfigured.

**Solution:**
```bash
# If using Minikube
minikube status
minikube start

# If using Kind
kind get clusters
kind create cluster

# Check kubeconfig
kubectl config view
```

### Issue: "Error from server (Forbidden)"

**Cause:** Insufficient permissions.

**Solution:**
- Check your user has proper RBAC permissions
- Verify you're using the correct context
- Contact cluster administrator

### Issue: "No resources found"

**Cause:** Either no resources exist, or you're looking in the wrong namespace.

**Solution:**
```bash
# Check all namespaces
kubectl get <resource> -A

# Verify current namespace
kubectl config view --minify | grep namespace
```

---

## Key Takeaways

✅ **kubectl is your primary tool** for interacting with Kubernetes  
✅ **Namespaces organize resources** and provide isolation  
✅ **Context determines** which cluster, user, and namespace you're using  
✅ **kubectl explain** provides built-in documentation  
✅ **Describe gives detailed information** about resources  
✅ **Multiple output formats** help with different use cases  

---

## Next Steps

You've mastered Kubernetes basics! You can now:
- Verify cluster health
- Navigate namespaces
- Explore cluster resources
- Use kubectl effectively

**Ready for Level 2?** Proceed to [02-pods-deployments.md](./02-pods-deployments.md) to learn about deploying applications with Pods and Deployments.

---

## Additional Resources

- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [kubectl Commands Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)

---

*Level 1 Complete! 🎉*
