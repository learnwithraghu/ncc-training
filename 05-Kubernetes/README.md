# Module 5: Kubernetes - Container Orchestration

**From Zero to Hero: Master Kubernetes in 5 Progressive Levels**

## 🎯 Module Overview

Welcome to the Kubernetes module! This comprehensive guide takes you from basic cluster operations to advanced orchestration concepts. Kubernetes (K8s) is the industry-standard container orchestration platform that automates deployment, scaling, and management of containerized applications.

### What You'll Learn

By completing this module, you will:

✅ Understand Kubernetes architecture and core concepts  
✅ Manage pods, deployments, and replica sets  
✅ Configure services and networking  
✅ Implement persistent storage and configuration management  
✅ Deploy stateful applications and scheduled jobs  
✅ Apply production-ready best practices  
✅ Monitor and troubleshoot K8s applications

---

## 📋 Prerequisites

Before starting this module, ensure you have:

- ✅ **Kubernetes cluster set up and running** (Minikube, Kind, or cloud-based)
- ✅ **kubectl installed** and configured
- ✅ Completion of Module 3 (Docker) - **Required**
- ✅ Basic understanding of containerization
- ✅ Terminal/command-line proficiency

### Verify Your Setup

```bash
# Check kubectl is installed
kubectl version --client

# Verify cluster connection
kubectl cluster-info

# Check cluster nodes
kubectl get nodes

# Verify you can create resources
kubectl auth can-i create deployments
```

---

## 🎓 Learning Path

This module is organized into **5 progressive levels**, each building on the previous:

```
Level 1: Kubernetes Basics           → Cluster fundamentals
Level 2: Pods & Deployments          → Application deployment
Level 3: Services & Networking       → Connectivity & exposure
Level 4: Storage & Configuration     → Data persistence & config
Level 5: Advanced Topics             → Production-ready patterns
```

### Recommended Approach

1. **Read [00-OVERVIEW.md](./00-OVERVIEW.md)** for theoretical foundation
2. **Follow levels sequentially** (01 → 02 → 03 → 04 → 05)
3. **Practice all commands** in your cluster
4. **Apply YAML manifests** from level subfolders
5. **Experiment and break things** - that's how you learn!

---

## 📚 Module Contents

| File/Folder | Description | Duration |
|-------------|-------------|----------|
| [00-OVERVIEW.md](./00-OVERVIEW.md) | Comprehensive K8s theory and architecture | 30 min |
| [01-basics.md](./01-basics.md) | **Level 1:** Cluster basics and kubectl | 45 min |
| [02-pods-deployments.md](./02-pods-deployments.md) | **Level 2:** Pods, deployments, scaling | 60 min |
| [03-services-networking.md](./03-services-networking.md) | **Level 3:** Services, ingress, networking | 60 min |
| [04-storage-config.md](./04-storage-config.md) | **Level 4:** Volumes, ConfigMaps, Secrets | 60 min |
| [05-advanced.md](./05-advanced.md) | **Level 5:** StatefulSets, Jobs, Helm | 90 min |
| `level-01-basics/` | Scripts and manifests for Level 1 | - |
| `level-02-pods-deployments/` | Scripts and manifests for Level 2 | - |
| `level-03-services-networking/` | Scripts and manifests for Level 3 | - |
| `level-04-storage-config/` | Scripts and manifests for Level 4 | - |
| `level-05-advanced/` | Scripts and manifests for Level 5 | - |

**Total Duration:** 5-6 hours (including hands-on practice)

---

## 🚀 Quick Command Reference

### Level 1: Basics

```bash
# Cluster information
kubectl cluster-info
kubectl get nodes
kubectl get namespaces

# Create namespace
kubectl create namespace dev
kubectl get ns

# Context management
kubectl config get-contexts
kubectl config use-context <context-name>

# Get resource information
kubectl get all
kubectl get pods --all-namespaces
kubectl describe node <node-name>

# Explain resources
kubectl explain pod
kubectl explain deployment.spec
```

### Level 2: Pods & Deployments

```bash
# Create a pod
kubectl run nginx --image=nginx
kubectl get pods
kubectl describe pod nginx

# Create from YAML
kubectl apply -f level-02-pods-deployments/simple-pod.yaml
kubectl get pods -o wide

# Create deployment
kubectl create deployment nginx-deploy --image=nginx --replicas=3
kubectl get deployments
kubectl get replicasets

# Scale deployment
kubectl scale deployment nginx-deploy --replicas=5
kubectl get pods

# Update deployment
kubectl set image deployment/nginx-deploy nginx=nginx:1.21
kubectl rollout status deployment/nginx-deploy

# Rollback deployment
kubectl rollout undo deployment/nginx-deploy
kubectl rollout history deployment/nginx-deploy

# Delete resources
kubectl delete pod nginx
kubectl delete deployment nginx-deploy
```

### Level 3: Services & Networking

```bash
# Create ClusterIP service
kubectl expose deployment nginx-deploy --port=80 --target-port=80
kubectl get services
kubectl describe service nginx-deploy

# Create from YAML
kubectl apply -f level-03-services-networking/clusterip-service.yaml
kubectl apply -f level-03-services-networking/nodeport-service.yaml

# Get service endpoints
kubectl get endpoints
kubectl get svc -o wide

# Port forwarding
kubectl port-forward service/nginx-deploy 8080:80

# Create ingress
kubectl apply -f level-03-services-networking/ingress-example.yaml
kubectl get ingress

# DNS testing
kubectl run test-pod --image=busybox --rm -it -- sh
# Inside pod: nslookup nginx-deploy

# Network policies
kubectl apply -f level-03-services-networking/network-policy.yaml
kubectl get networkpolicies
```

### Level 4: Storage & Configuration

```bash
# Create ConfigMap
kubectl create configmap app-config --from-literal=ENV=production
kubectl get configmaps
kubectl describe configmap app-config

# Create from file
kubectl create configmap app-config --from-file=config.properties
kubectl apply -f level-04-storage-config/configmap-demo.yaml

# Create Secret
kubectl create secret generic db-secret --from-literal=password=mypassword
kubectl get secrets
kubectl describe secret db-secret

# Create from YAML
kubectl apply -f level-04-storage-config/secret-demo.yaml

# View secret data (base64 encoded)
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 --decode

# Persistent Volumes
kubectl apply -f level-04-storage-config/pv-example.yaml
kubectl get pv

# Persistent Volume Claims
kubectl apply -f level-04-storage-config/pvc-example.yaml
kubectl get pvc

# Pod with volume mount
kubectl apply -f level-04-storage-config/volume-mount-pod.yaml
kubectl exec -it <pod-name> -- ls /data
```

### Level 5: Advanced Topics

```bash
# StatefulSet
kubectl apply -f level-05-advanced/statefulset-example.yaml
kubectl get statefulsets
kubectl get pods -l app=web

# DaemonSet
kubectl apply -f level-05-advanced/daemonset-example.yaml
kubectl get daemonsets

# Job
kubectl create job hello --image=busybox -- echo "Hello Kubernetes"
kubectl get jobs
kubectl logs job/hello

# CronJob
kubectl apply -f level-05-advanced/cronjob-example.yaml
kubectl get cronjobs

# Resource limits
kubectl apply -f level-05-advanced/resource-limits-pod.yaml
kubectl describe pod <pod-name> | grep -A 5 "Limits"

# Health checks
kubectl apply -f level-05-advanced/health-checks-pod.yaml
kubectl describe pod <pod-name> | grep -A 10 "Liveness"

# Top commands (requires metrics-server)
kubectl top nodes
kubectl top pods

# Helm basics
helm version
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo nginx
helm install my-nginx bitnami/nginx
helm list
helm uninstall my-nginx
```

---

## 🔍 Common kubectl Commands

### Resource Management

```bash
# Get resources
kubectl get <resource>                    # List resources
kubectl get <resource> -o wide            # More details
kubectl get <resource> -o yaml            # YAML output
kubectl get <resource> -o json            # JSON output
kubectl get all                           # All resources in namespace

# Describe resources
kubectl describe <resource> <name>        # Detailed info

# Create resources
kubectl create -f <file.yaml>             # Create from file
kubectl apply -f <file.yaml>              # Create or update
kubectl apply -f <directory>/             # Apply all in directory

# Delete resources
kubectl delete <resource> <name>          # Delete by name
kubectl delete -f <file.yaml>             # Delete from file
kubectl delete <resource> --all           # Delete all in namespace

# Edit resources
kubectl edit <resource> <name>            # Edit in default editor
kubectl patch <resource> <name> -p '{}'   # Patch resource
```

### Debugging & Troubleshooting

```bash
# Logs
kubectl logs <pod-name>                   # View pod logs
kubectl logs <pod-name> -f                # Follow logs
kubectl logs <pod-name> -c <container>    # Specific container
kubectl logs <pod-name> --previous        # Previous instance

# Execute commands
kubectl exec <pod-name> -- <command>      # Run command
kubectl exec -it <pod-name> -- /bin/sh    # Interactive shell

# Copy files
kubectl cp <pod-name>:/path/to/file ./local/path
kubectl cp ./local/file <pod-name>:/path/to/file

# Events
kubectl get events                        # Cluster events
kubectl get events --sort-by='.lastTimestamp'

# Resource usage
kubectl top nodes                         # Node metrics
kubectl top pods                          # Pod metrics
kubectl top pods --containers             # Container metrics
```

### Namespace Operations

```bash
# Work with namespaces
kubectl get namespaces
kubectl create namespace <name>
kubectl delete namespace <name>

# Set default namespace
kubectl config set-context --current --namespace=<name>

# All namespaces
kubectl get pods --all-namespaces
kubectl get pods -A                       # Short form
```

---

## 🛠️ Troubleshooting Guide

### Pod Issues

**Pod stuck in Pending:**
```bash
kubectl describe pod <pod-name>
# Check: Insufficient resources, PVC not bound, node selector issues
```

**Pod in CrashLoopBackOff:**
```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl describe pod <pod-name>
# Check: Application errors, missing dependencies, health check failures
```

**ImagePullBackOff:**
```bash
kubectl describe pod <pod-name>
# Check: Image name typo, private registry auth, network issues
```

### Service Issues

**Service not accessible:**
```bash
kubectl get endpoints <service-name>
kubectl describe service <service-name>
# Check: Selector labels match pods, port configuration, network policies
```

### General Debugging

```bash
# Check cluster health
kubectl get componentstatuses
kubectl cluster-info dump

# Verify YAML syntax
kubectl apply -f <file.yaml> --dry-run=client

# Validate resource
kubectl apply -f <file.yaml> --validate=true --dry-run=client

# Get API resources
kubectl api-resources
kubectl api-versions
```

---

## 💡 Best Practices

### Resource Naming
- Use lowercase and hyphens: `my-app-deployment`
- Include environment: `my-app-prod`, `my-app-dev`
- Be descriptive and consistent

### Labels & Selectors
```yaml
labels:
  app: myapp
  environment: production
  version: v1.0
  tier: frontend
```

### Resource Requests & Limits
Always define for production:
```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

### Health Checks
Implement both liveness and readiness probes:
```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
```

### Security
- Use namespaces for isolation
- Implement RBAC (Role-Based Access Control)
- Use secrets for sensitive data
- Apply network policies
- Run containers as non-root
- Use security contexts

---

## 📖 Additional Resources

### Official Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)

### Interactive Learning
- [Kubernetes Tutorials](https://kubernetes.io/docs/tutorials/)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [Katacoda Kubernetes Scenarios](https://www.katacoda.com/courses/kubernetes)

### Tools
- [k9s](https://k9scli.io/) - Terminal UI for Kubernetes
- [Lens](https://k8slens.dev/) - Kubernetes IDE
- [Helm](https://helm.sh/) - Package manager for Kubernetes
- [kubectx/kubens](https://github.com/ahmetb/kubectx) - Context/namespace switcher

---

## ✅ Level Completion Checklist

### Level 1: Basics
- [ ] Verified cluster is running
- [ ] Explored cluster nodes and namespaces
- [ ] Practiced basic kubectl commands
- [ ] Created and deleted namespaces
- [ ] Understood kubectl context management

### Level 2: Pods & Deployments
- [ ] Created pods from command line and YAML
- [ ] Deployed applications with deployments
- [ ] Scaled deployments up and down
- [ ] Performed rolling updates
- [ ] Rolled back deployments
- [ ] Used labels and selectors

### Level 3: Services & Networking
- [ ] Created ClusterIP, NodePort services
- [ ] Tested service discovery and DNS
- [ ] Used port forwarding for debugging
- [ ] Configured ingress rules
- [ ] Applied network policies

### Level 4: Storage & Configuration
- [ ] Created ConfigMaps and Secrets
- [ ] Mounted ConfigMaps as volumes
- [ ] Used environment variables from ConfigMaps
- [ ] Created PersistentVolumes and PVCs
- [ ] Attached storage to pods

### Level 5: Advanced Topics
- [ ] Deployed StatefulSets
- [ ] Created DaemonSets and Jobs
- [ ] Scheduled CronJobs
- [ ] Configured resource limits
- [ ] Implemented health checks
- [ ] Used Helm to deploy applications

---

## 🎯 Next Steps

After completing this module, you're ready for:

1. **Advanced Kubernetes Topics**
   - Custom Resource Definitions (CRDs)
   - Operators and controllers
   - Service mesh (Istio, Linkerd)
   - GitOps with ArgoCD or Flux

2. **Production Deployment**
   - Multi-cluster management
   - Disaster recovery strategies
   - Cost optimization
   - Security hardening

3. **Monitoring & Observability**
   - Prometheus and Grafana
   - ELK/EFK stack
   - Distributed tracing
   - Log aggregation

4. **CI/CD Integration**
   - Jenkins with Kubernetes
   - GitHub Actions
   - Tekton Pipelines
   - Spinnaker

---

## 🚀 Ready to Begin?

Start with [00-OVERVIEW.md](./00-OVERVIEW.md) to build your theoretical foundation, then proceed to [01-basics.md](./01-basics.md) for hands-on practice.

**Remember:** Kubernetes has a learning curve, but with consistent practice, you'll master it. Don't rush—take time to understand each concept before moving forward.

**Good luck on your Kubernetes journey!** ☸️

---

*Module Version: 1.0*  
*Last Updated: December 2025*
