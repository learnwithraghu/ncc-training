# Level 5: Advanced Topics

**Production-ready Kubernetes patterns and advanced workloads**

## Learning Objectives

By the end of this level, you will:

- ✅ Deploy stateful applications with StatefulSets
- ✅ Run background tasks with DaemonSets
- ✅ Execute batch jobs and scheduled tasks
- ✅ Configure resource limits and requests
- ✅ Implement health checks (liveness, readiness, startup probes)
- ✅ Use Helm for package management
- ✅ Apply production best practices

**Estimated Time:** 90 minutes

---

## 1. StatefulSets

### What are StatefulSets?

**StatefulSets** manage stateful applications that require:
- Stable, unique network identifiers
- Stable, persistent storage
- Ordered, graceful deployment and scaling
- Ordered, automated rolling updates

**Use cases**: Databases, message queues, distributed systems

### StatefulSet vs Deployment

| Feature | Deployment | StatefulSet |
|---------|-----------|-------------|
| Pod names | Random | Predictable (app-0, app-1) |
| Network identity | Unstable | Stable (DNS) |
| Storage | Shared or none | Dedicated PVC per pod |
| Scaling | Parallel | Sequential |
| Updates | Rolling | Ordered |

### Create StatefulSet

```bash
kubectl apply -f level-05-advanced/statefulset-example.yaml
kubectl get statefulsets
kubectl get sts

# Watch pods being created sequentially
kubectl get pods --watch
```

### StatefulSet Pods

```bash
# List pods (notice predictable names)
kubectl get pods -l app=web

# Each pod gets its own DNS entry
# Format: <pod-name>.<service-name>.<namespace>.svc.cluster.local
# Example: web-0.nginx.default.svc.cluster.local
```

### Scale StatefulSet

```bash
# Scale up (sequential)
kubectl scale statefulset web --replicas=5

# Scale down (reverse order)
kubectl scale statefulset web --replicas=2
```

### Delete StatefulSet

```bash
# Delete StatefulSet (keeps PVCs)
kubectl delete statefulset web

# Delete PVCs manually
kubectl delete pvc -l app=web
```

---

## 2. DaemonSets

### What are DaemonSets?

**DaemonSets** ensure a copy of a pod runs on all (or some) nodes.

**Use cases**:
- Log collectors (Fluentd, Logstash)
- Monitoring agents (Prometheus Node Exporter)
- Storage daemons (Ceph, Gluster)
- Network plugins (Calico, Weave)

### Create DaemonSet

```bash
kubectl apply -f level-05-advanced/daemonset-example.yaml
kubectl get daemonsets
kubectl get ds

# One pod per node
kubectl get pods -o wide
```

### Node Selectors

DaemonSets can target specific nodes:

```yaml
spec:
  template:
    spec:
      nodeSelector:
        disktype: ssd
```

---

## 3. Jobs

### What are Jobs?

**Jobs** create one or more pods and ensure they successfully terminate.

**Use cases**:
- Batch processing
- Data migrations
- Report generation
- One-time tasks

### Create Job

```bash
# Imperative
kubectl create job hello --image=busybox -- echo "Hello Kubernetes"

# View job
kubectl get jobs

# View pods
kubectl get pods

# View logs
kubectl logs job/hello
```

### Job from YAML

```bash
kubectl apply -f level-05-advanced/job-example.yaml
kubectl get jobs
kubectl logs job/pi-calculation
```

### Parallel Jobs

```yaml
spec:
  completions: 5      # Run 5 times
  parallelism: 2      # 2 pods at a time
```

### Delete Job

```bash
# Delete job and its pods
kubectl delete job hello
```

---

## 4. CronJobs

### What are CronJobs?

**CronJobs** run jobs on a schedule (like cron in Linux).

**Use cases**:
- Scheduled backups
- Report generation
- Data cleanup
- Health checks

### Create CronJob

```bash
kubectl apply -f level-05-advanced/cronjob-example.yaml
kubectl get cronjobs
kubectl get cj
```

### CronJob Schedule

Uses cron format:
```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 6)
# │ │ │ │ │
# * * * * *
```

**Examples**:
- `*/5 * * * *` - Every 5 minutes
- `0 * * * *` - Every hour
- `0 0 * * *` - Every day at midnight
- `0 0 * * 0` - Every Sunday at midnight

### View CronJob Runs

```bash
# View jobs created by CronJob
kubectl get jobs

# View pods
kubectl get pods

# View logs
kubectl logs <pod-name>
```

### Manually Trigger CronJob

```bash
kubectl create job manual-run --from=cronjob/hello-cron
```

---

## 5. Resource Limits and Requests

### Why Resource Management?

- **Requests**: Minimum resources guaranteed
- **Limits**: Maximum resources allowed

### Resource Types

- **CPU**: Measured in cores (1000m = 1 core)
- **Memory**: Measured in bytes (Mi, Gi)

### Apply Resource Limits

```bash
kubectl apply -f level-05-advanced/resource-limits-pod.yaml
kubectl get pods
kubectl describe pod resource-demo
```

### View Resource Usage

```bash
# Requires metrics-server
kubectl top nodes
kubectl top pods
kubectl top pod resource-demo
```

### QoS Classes

Kubernetes assigns QoS based on resources:

1. **Guaranteed**: Requests = Limits (highest priority)
2. **Burstable**: Requests < Limits
3. **BestEffort**: No requests/limits (lowest priority)

```bash
kubectl describe pod <pod-name> | grep "QoS Class"
```

---

## 6. Health Checks

### Probe Types

**Liveness Probe**: Is the container alive? (restart if fails)  
**Readiness Probe**: Is the container ready for traffic? (remove from service if fails)  
**Startup Probe**: Has the container started? (for slow-starting apps)

### Probe Mechanisms

- **HTTP GET**: Check HTTP endpoint
- **TCP Socket**: Check TCP port
- **Exec**: Run command in container

### Apply Health Checks

```bash
kubectl apply -f level-05-advanced/health-checks-pod.yaml
kubectl get pods
kubectl describe pod health-check-pod
```

### Test Liveness Probe

```bash
# Watch pod
kubectl get pods --watch

# In another terminal, break the health check
kubectl exec health-check-pod -- rm /usr/share/nginx/html/index.html

# Pod will be restarted automatically
```

### Health Check Best Practices

✅ Always implement liveness and readiness probes  
✅ Use different endpoints for liveness and readiness  
✅ Set appropriate timeouts and thresholds  
✅ Don't check external dependencies in liveness probes  
✅ Use startup probes for slow-starting applications  

---

## 7. Helm Basics

### What is Helm?

**Helm** is a package manager for Kubernetes (like apt/yum for Linux).

**Benefits**:
- Package applications as charts
- Manage dependencies
- Version and rollback releases
- Share charts via repositories

### Install Helm

```bash
# Check if Helm is installed
helm version

# If not installed, visit: https://helm.sh/docs/intro/install/
```

### Helm Repositories

```bash
# Add Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories
helm repo update

# Search for charts
helm search repo nginx
helm search repo mysql
```

### Install a Chart

```bash
# Install nginx
helm install my-nginx bitnami/nginx

# List releases
helm list
helm ls

# Get release status
helm status my-nginx
```

### View Installed Resources

```bash
kubectl get all -l app.kubernetes.io/instance=my-nginx
```

### Upgrade Release

```bash
helm upgrade my-nginx bitnami/nginx --set replicaCount=3
```

### Rollback Release

```bash
# View history
helm history my-nginx

# Rollback
helm rollback my-nginx 1
```

### Uninstall Release

```bash
helm uninstall my-nginx
```

### Create Your Own Chart

```bash
# Create chart scaffold
helm create my-app

# View structure
ls my-app/

# Install your chart
helm install my-release ./my-app
```

---

## 8. Production Best Practices

### Security

✅ Use RBAC for access control  
✅ Enable Pod Security Standards  
✅ Scan images for vulnerabilities  
✅ Use network policies  
✅ Encrypt secrets at rest  
✅ Run containers as non-root  
✅ Use read-only root filesystems  

### Reliability

✅ Set resource requests and limits  
✅ Implement health checks  
✅ Use multiple replicas  
✅ Configure pod disruption budgets  
✅ Use anti-affinity for high availability  
✅ Implement graceful shutdown  

### Observability

✅ Centralize logging (ELK, Loki)  
✅ Monitor metrics (Prometheus, Grafana)  
✅ Implement distributed tracing  
✅ Set up alerting  
✅ Use dashboards  

### Performance

✅ Right-size resources  
✅ Use horizontal pod autoscaling  
✅ Optimize images (multi-stage builds)  
✅ Use caching effectively  
✅ Implement CDN for static assets  

---

## 9. Hands-On Practice

### Exercise 1: StatefulSet

1. Deploy a StatefulSet with 3 replicas
2. Verify predictable pod names
3. Scale up and down
4. Observe sequential scaling

### Exercise 2: Jobs and CronJobs

1. Create a Job that calculates pi
2. Create a CronJob that runs every minute
3. View job history
4. Manually trigger a CronJob

### Exercise 3: Resource Management

1. Create a pod with resource limits
2. View resource usage with `kubectl top`
3. Check QoS class
4. Test what happens when limits are exceeded

### Exercise 4: Health Checks

1. Deploy a pod with liveness and readiness probes
2. Break the liveness probe
3. Observe automatic restart
4. Fix and verify recovery

### Exercise 5: Helm

1. Add a Helm repository
2. Search for a chart
3. Install a release
4. Upgrade the release
5. Rollback and uninstall

---

## 10. Monitoring and Logging

### Install Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Verify
kubectl top nodes
kubectl top pods
```

### View Logs

```bash
# Pod logs
kubectl logs <pod-name>
kubectl logs <pod-name> -f
kubectl logs <pod-name> --previous

# Logs from all pods in deployment
kubectl logs deployment/<deployment-name>

# Logs with timestamps
kubectl logs <pod-name> --timestamps
```

### Events

```bash
# View events
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector type=Warning
```

---

## Key Takeaways

✅ **StatefulSets** for stateful applications  
✅ **DaemonSets** run on every node  
✅ **Jobs** for one-time tasks, **CronJobs** for scheduled tasks  
✅ **Resource limits** prevent resource exhaustion  
✅ **Health checks** ensure reliability  
✅ **Helm** simplifies application management  
✅ **Production requires** security, reliability, and observability  

---

## Congratulations! 🎉

You've completed the Kubernetes 0-to-Hero course! You now have the skills to:

- Deploy and manage applications in Kubernetes
- Configure networking and services
- Manage storage and configuration
- Implement advanced workload patterns
- Apply production best practices

### Next Steps

1. **Practice**: Deploy real applications
2. **Explore**: CRDs, Operators, Service Meshes
3. **Certify**: Consider CKA, CKAD, or CKS certifications
4. **Contribute**: Join the Kubernetes community

### Additional Learning

- **Advanced Topics**: Operators, Custom Resources, Admission Controllers
- **Multi-Cluster**: Federation, Multi-Cluster Management
- **Service Mesh**: Istio, Linkerd, Consul
- **GitOps**: ArgoCD, Flux
- **Security**: OPA, Falco, Trivy

---

*Level 5 Complete! You're now a Kubernetes Hero! ☸️🎉*
