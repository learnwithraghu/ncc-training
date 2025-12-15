# Level 2: Pods & Deployments

**Deploy and manage applications in Kubernetes**

## Learning Objectives

By the end of this level, you will:

- ✅ Create and manage pods
- ✅ Understand pod lifecycle and states
- ✅ Deploy applications using Deployments
- ✅ Scale applications horizontally
- ✅ Perform rolling updates and rollbacks
- ✅ Use labels and selectors effectively
- ✅ Manage ReplicaSets

**Estimated Time:** 60 minutes

---

## Prerequisites

- Completion of Level 1 (Kubernetes Basics)
- Running Kubernetes cluster
- kubectl configured

---

## 1. Understanding Pods

### What is a Pod?

A **Pod** is the smallest deployable unit in Kubernetes. It represents a single instance of a running process in your cluster.

**Key characteristics:**
- Can contain one or more containers
- Containers in a pod share network namespace (same IP)
- Containers in a pod share storage volumes
- Pods are ephemeral (temporary)
- Each pod gets a unique IP address

### Create Your First Pod

**Imperative approach** (command-line):

```bash
kubectl run nginx --image=nginx
```

Check if it's running:

```bash
kubectl get pods
```

**Expected output:**
```
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          10s
```

### Pod Status Explained

- **Pending**: Pod accepted but not yet running (downloading image, scheduling)
- **Running**: Pod bound to node, all containers created, at least one running
- **Succeeded**: All containers terminated successfully
- **Failed**: All containers terminated, at least one failed
- **Unknown**: Pod state cannot be determined

### Get Detailed Pod Information

```bash
# More details
kubectl get pods -o wide

# Full description
kubectl describe pod nginx

# Pod YAML
kubectl get pod nginx -o yaml
```

### Delete a Pod

```bash
kubectl delete pod nginx
```

---

## 2. Creating Pods from YAML

### Declarative Approach

Create a pod using a YAML manifest:

```bash
kubectl apply -f level-02-pods-deployments/simple-pod.yaml
```

View the YAML file:

```bash
cat level-02-pods-deployments/simple-pod.yaml
```

**Basic pod structure:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

### Multi-Container Pods

Pods can run multiple containers:

```bash
kubectl apply -f level-02-pods-deployments/multi-container-pod.yaml
```

**Use cases for multi-container pods:**
- **Sidecar pattern**: Logging, monitoring agents
- **Adapter pattern**: Normalize output
- **Ambassador pattern**: Proxy connections

### Accessing Container Logs

```bash
# Single container pod
kubectl logs nginx-pod

# Multi-container pod (specify container)
kubectl logs multi-container-pod -c nginx
kubectl logs multi-container-pod -c sidecar

# Follow logs (like tail -f)
kubectl logs nginx-pod -f

# Previous container instance
kubectl logs nginx-pod --previous
```

### Execute Commands in Pods

```bash
# Run a command
kubectl exec nginx-pod -- ls /usr/share/nginx/html

# Interactive shell
kubectl exec -it nginx-pod -- /bin/bash

# Inside the pod, try:
# cat /etc/nginx/nginx.conf
# curl localhost
# exit
```

---

## 3. Deployments

### Why Deployments?

Pods alone have limitations:
- If a pod dies, it's not automatically recreated
- No easy way to scale
- No rolling updates
- Manual management is tedious

**Deployments solve this** by providing:
- Desired state management
- Automatic pod recreation
- Easy scaling
- Rolling updates and rollbacks
- ReplicaSet management

### Create a Deployment

**Imperative:**

```bash
kubectl create deployment nginx-deploy --image=nginx --replicas=3
```

**Declarative:**

```bash
kubectl apply -f level-02-pods-deployments/nginx-deployment.yaml
```

### View Deployments

```bash
# List deployments
kubectl get deployments
kubectl get deploy

# Detailed view
kubectl get deploy -o wide

# Describe deployment
kubectl describe deployment nginx-deploy
```

### Understanding ReplicaSets

Deployments create ReplicaSets, which manage pods:

```bash
# View ReplicaSets
kubectl get replicasets
kubectl get rs

# See the relationship
kubectl get deploy,rs,pods
```

**Hierarchy:**
```
Deployment → ReplicaSet → Pods
```

---

## 4. Scaling Applications

### Manual Scaling

Scale up:

```bash
kubectl scale deployment nginx-deploy --replicas=5
```

Watch the scaling happen:

```bash
kubectl get pods --watch
```

Scale down:

```bash
kubectl scale deployment nginx-deploy --replicas=2
```

### Edit Deployment

```bash
kubectl edit deployment nginx-deploy
```

This opens the deployment in your default editor. Change `replicas: 2` to `replicas: 4`, save and exit.

### Verify Scaling

```bash
kubectl get deploy nginx-deploy
kubectl get pods
```

---

## 5. Rolling Updates

### Update Container Image

Update to a new nginx version:

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:1.22
```

Watch the rollout:

```bash
kubectl rollout status deployment/nginx-deploy
```

**What happens:**
1. New ReplicaSet created with new image
2. New pods gradually created
3. Old pods gradually terminated
4. Zero downtime!

### View Rollout History

```bash
kubectl rollout history deployment/nginx-deploy
```

### Update with Record

To track changes in history:

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:1.23 --record
```

**Note:** `--record` is deprecated but still useful for learning.

---

## 6. Rollbacks

### Simulate a Bad Deployment

Deploy a non-existent image:

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:broken
```

Check status:

```bash
kubectl rollout status deployment/nginx-deploy
kubectl get pods
```

You'll see pods in `ImagePullBackOff` state.

### Rollback to Previous Version

```bash
kubectl rollout undo deployment/nginx-deploy
```

Verify:

```bash
kubectl rollout status deployment/nginx-deploy
kubectl get pods
```

### Rollback to Specific Revision

```bash
# View history
kubectl rollout history deployment/nginx-deploy

# Rollback to specific revision
kubectl rollout history deployment/nginx-deploy --revision=2
kubectl rollout undo deployment/nginx-deploy --to-revision=2
```

---

## 7. Labels and Selectors

### Understanding Labels

Labels are key-value pairs attached to objects:

```yaml
metadata:
  labels:
    app: nginx
    environment: production
    tier: frontend
```

### View Labels

```bash
# Show labels
kubectl get pods --show-labels

# Show specific label as column
kubectl get pods -L app,environment
```

### Add Labels

```bash
kubectl label pod nginx-pod version=v1
kubectl label pod nginx-pod tier=frontend
```

### Remove Labels

```bash
kubectl label pod nginx-pod version-
```

### Label Selectors

Filter resources by labels:

```bash
# Equality-based
kubectl get pods -l app=nginx
kubectl get pods -l environment=production

# Set-based
kubectl get pods -l 'app in (nginx, apache)'
kubectl get pods -l 'environment notin (dev, test)'

# Multiple conditions
kubectl get pods -l app=nginx,environment=production
```

### Deployment Selectors

Deployments use selectors to manage pods:

```bash
kubectl describe deployment nginx-deploy | grep Selector
```

---

## 8. Pod Lifecycle Management

### Restart Pods

Delete pods (deployment recreates them):

```bash
kubectl delete pod <pod-name>
kubectl get pods --watch
```

### Pause and Resume Rollouts

```bash
# Pause (prevents updates from triggering rollouts)
kubectl rollout pause deployment/nginx-deploy

# Make changes
kubectl set image deployment/nginx-deploy nginx=nginx:1.24
kubectl set resources deployment/nginx-deploy -c=nginx --limits=cpu=200m,memory=512Mi

# Resume (triggers rollout with all changes)
kubectl rollout resume deployment/nginx-deploy
```

### Delete Deployment

```bash
kubectl delete deployment nginx-deploy
```

This deletes the deployment, ReplicaSet, and all pods.

---

## 9. Hands-On Practice

### Exercise 1: Create and Manage Pods

1. Create a pod running Apache (httpd image)
2. View pod details
3. Check pod logs
4. Execute a command inside the pod
5. Delete the pod

```bash
kubectl run apache --image=httpd
kubectl get pods
kubectl describe pod apache
kubectl logs apache
kubectl exec apache -- ls /usr/local/apache2/htdocs
kubectl delete pod apache
```

### Exercise 2: Deploy with Deployments

1. Create a deployment with 3 replicas of nginx
2. Verify all pods are running
3. Scale to 5 replicas
4. Scale back to 2 replicas
5. Delete the deployment

```bash
kubectl create deployment web --image=nginx --replicas=3
kubectl get deploy,rs,pods
kubectl scale deployment web --replicas=5
kubectl get pods
kubectl scale deployment web --replicas=2
kubectl delete deployment web
```

### Exercise 3: Rolling Updates and Rollbacks

1. Create a deployment with nginx:1.21
2. Update to nginx:1.22
3. Check rollout status
4. Update to a broken image (nginx:broken)
5. Rollback to previous version
6. View rollout history

```bash
kubectl create deployment app --image=nginx:1.21 --replicas=3
kubectl set image deployment/app nginx=nginx:1.22
kubectl rollout status deployment/app
kubectl set image deployment/app nginx=nginx:broken
kubectl get pods
kubectl rollout undo deployment/app
kubectl rollout history deployment/app
```

### Exercise 4: Labels and Selectors

1. Create pods with different labels
2. List pods with specific labels
3. Add/remove labels
4. Use label selectors to filter

```bash
kubectl run pod1 --image=nginx --labels="app=web,env=prod"
kubectl run pod2 --image=nginx --labels="app=web,env=dev"
kubectl run pod3 --image=nginx --labels="app=api,env=prod"
kubectl get pods --show-labels
kubectl get pods -l app=web
kubectl get pods -l env=prod
kubectl get pods -l app=web,env=prod
kubectl label pod pod1 version=v1
kubectl get pods --show-labels
kubectl delete pods -l app=web
```

### Exercise 5: Run the Demo Scripts

```bash
# Scaling demonstration
bash level-02-pods-deployments/scaling-demo.sh

# Rolling update and rollback demonstration
bash level-02-pods-deployments/rollout-demo.sh
```

---

## 10. Common Issues and Solutions

### Issue: ImagePullBackOff

**Cause:** Cannot pull container image.

**Solutions:**
```bash
# Check image name
kubectl describe pod <pod-name> | grep Image

# Check events
kubectl describe pod <pod-name> | grep -A 10 Events

# Verify image exists
docker pull <image-name>
```

### Issue: CrashLoopBackOff

**Cause:** Container starts then crashes repeatedly.

**Solutions:**
```bash
# Check logs
kubectl logs <pod-name>
kubectl logs <pod-name> --previous

# Describe pod
kubectl describe pod <pod-name>

# Check container command/args
kubectl get pod <pod-name> -o yaml | grep -A 5 command
```

### Issue: Pods Stuck in Pending

**Cause:** Cannot be scheduled (insufficient resources, node selector).

**Solutions:**
```bash
# Check events
kubectl describe pod <pod-name>

# Check node resources
kubectl describe nodes

# Check if nodes are ready
kubectl get nodes
```

---

## Key Takeaways

✅ **Pods are ephemeral** - design for failure  
✅ **Deployments manage pods** - use them instead of bare pods  
✅ **Scaling is easy** - horizontal scaling with one command  
✅ **Rolling updates** - zero-downtime deployments  
✅ **Rollbacks** - quickly revert bad deployments  
✅ **Labels and selectors** - organize and filter resources  

---

## Next Steps

You've mastered pods and deployments! You can now:
- Deploy containerized applications
- Scale applications up and down
- Perform rolling updates
- Rollback failed deployments
- Use labels effectively

**Ready for Level 3?** Proceed to [03-services-networking.md](./03-services-networking.md) to learn how to expose your applications and configure networking.

---

*Level 2 Complete! 🎉*
