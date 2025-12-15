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

> [!NOTE]
> **Instructor Note: Why We Start with Pods**
>
> We begin with Pods because they are the fundamental building block of Kubernetes - you cannot deploy anything without understanding them first. Think of Pods as the "atoms" of Kubernetes; everything else is built on top of them. While in production you'll rarely create standalone Pods (you'll use Deployments instead), understanding Pods is crucial because it helps you troubleshoot issues, read logs, and understand how Kubernetes actually runs your applications. When something goes wrong in production, you'll be debugging at the Pod level, not the Deployment level. Additionally, understanding that Pods are ephemeral (temporary) is a fundamental shift in mindset from traditional server management - this concept of treating infrastructure as disposable is core to cloud-native thinking and will influence how you design applications throughout your career.

### What is a Pod?

A **Pod** is the smallest deployable unit in Kubernetes. It represents a single instance of a running process in your cluster.

**Key characteristics:**
- Can contain one or more containers
- Containers in a pod share network namespace (same IP)
- Containers in a pod share storage volumes
- Pods are ephemeral (temporary)
- Each pod gets a unique IP address

### Create Your First Pod

We'll use the imperative approach for your very first pod to see immediate results:

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

> [!IMPORTANT]
> **Instructor Note: Why We Use YAML (Declarative Approach)**
>
> While we just created a pod using a simple command (imperative), in real-world scenarios you'll always use YAML files (declarative approach). Here's why: YAML files serve as documentation and version control for your infrastructure. When you define your infrastructure as code in YAML files, you can commit them to Git, review changes through pull requests, and track exactly what changed over time. This is called "Infrastructure as Code" (IaC) and is a fundamental DevOps practice. Additionally, YAML files are reproducible - you can deploy the exact same configuration across development, staging, and production environments. The imperative approach (kubectl run) is great for quick testing and learning, but it doesn't leave a trail of what you did. In production, if someone asks "what's running in our cluster?", you can point them to YAML files in Git rather than trying to remember commands you ran weeks ago. This shift from imperative to declarative is one of the most important concepts in modern infrastructure management.

### Declarative Approach with YAML

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

> [!IMPORTANT]
> **Instructor Note: Why Deployments Are Essential**
>
> This is where Kubernetes truly shines and differentiates itself from simply running Docker containers. Imagine you're running a production web application serving thousands of users. If you only use Pods, and one crashes at 3 AM, your application goes down until someone manually creates a new Pod. With Deployments, Kubernetes automatically recreates failed Pods - it's self-healing. But it goes beyond that: Deployments enable you to scale your application from 3 instances to 100 instances with a single command, and they allow you to update your application to a new version without any downtime through rolling updates. This is the difference between managing servers like pets (each one is special and manually maintained) versus managing them like cattle (they're identical and automatically replaced). In production, you'll almost never create standalone Pods - you'll always use Deployments. This concept of declaring your desired state ("I want 5 replicas running") and letting Kubernetes maintain that state is the core of Kubernetes' value proposition. It's what allows companies to deploy hundreds of times per day with confidence.

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

We'll use the declarative approach with YAML files, as this is the production-standard method:

```bash
kubectl apply -f level-02-pods-deployments/nginx-deployment.yaml
```

View the deployment YAML:

```bash
cat level-02-pods-deployments/nginx-deployment.yaml
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

> [!NOTE]
> **Instructor Note: Why Scaling Matters**
>
> Horizontal scaling (adding more instances) is one of the most powerful features of Kubernetes and cloud-native applications. In traditional infrastructure, if your application gets more traffic, you'd need to provision larger servers (vertical scaling), which requires downtime and has physical limits. With Kubernetes, you can scale horizontally by adding more Pod replicas, which can be done instantly without downtime. This is how companies like Netflix and Spotify handle millions of users - they run thousands of small instances rather than a few giant servers. Understanding scaling is crucial because traffic patterns are rarely constant; you might need 10 replicas during business hours but only 2 at night. While we're doing manual scaling here to understand the concept, in production you'll use Horizontal Pod Autoscaler (HPA) to automatically scale based on CPU usage or custom metrics. This exercise teaches you the foundation - how Kubernetes distributes load across replicas and maintains your desired state even as you change it.

### Manual Scaling

Scale up to 5 replicas:

```bash
kubectl scale deployment nginx-deploy --replicas=5
```

Watch the scaling happen in real-time:

```bash
kubectl get pods --watch
```

(Press Ctrl+C to stop watching)

Scale down to 2 replicas:

```bash
kubectl scale deployment nginx-deploy --replicas=2
```

### Verify Scaling

```bash
kubectl get deploy nginx-deploy
kubectl get pods
```

---

## 5. Rolling Updates

> [!IMPORTANT]
> **Instructor Note: Why Rolling Updates Are Revolutionary**
>
> Rolling updates represent a fundamental shift in how we deploy software. In traditional infrastructure, updating an application meant scheduling maintenance windows, taking the application offline, deploying the new version, and hoping everything works. With Kubernetes rolling updates, you can deploy new versions with zero downtime - your users never experience an outage. Here's how it works: Kubernetes gradually replaces old Pods with new ones, ensuring that some instances of your application are always running. If you have 5 replicas, it might create 1 new Pod, wait for it to be healthy, terminate 1 old Pod, and repeat until all are updated. This is why companies can deploy multiple times per day without impacting users. The beauty is that Kubernetes handles all the complexity - you just specify the new image version. This concept extends beyond just image updates; you can update environment variables, resource limits, or any configuration with the same zero-downtime approach. Understanding rolling updates is essential because it changes how you think about deployments - from risky, scheduled events to routine, safe operations that can happen anytime.

### Update Container Image

Update to a new nginx version:

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:1.22
```

Watch the rollout in real-time:

```bash
kubectl rollout status deployment/nginx-deploy
```

**What happens during a rolling update:**
1. New ReplicaSet created with new image
2. New pods gradually created
3. Old pods gradually terminated
4. Zero downtime!

### View Rollout History

```bash
kubectl rollout history deployment/nginx-deploy
```

---

## 6. Rollbacks

> [!CAUTION]
> **Instructor Note: Why Rollbacks Are Your Safety Net**
>
> Even with the best testing, bad deployments happen in production. A bug slips through, a configuration is wrong, or an external dependency fails. In traditional infrastructure, recovering from a bad deployment could take hours - you'd need to find the previous version, redeploy it, and hope you didn't lose data. Kubernetes rollbacks allow you to revert to a previous working version in seconds with a single command. This is possible because Kubernetes keeps a history of your deployments (stored as ReplicaSets). When you rollback, it doesn't redeploy from scratch - it simply scales up the old ReplicaSet and scales down the new one. This makes rollbacks incredibly fast and safe. In production, this capability is invaluable; if you deploy a change at 2 PM and discover a critical bug at 2:05 PM, you can rollback immediately while you investigate the issue. This safety net encourages more frequent deployments because the risk is lower - you can always rollback. Understanding rollbacks is crucial for building confidence in your deployment process and is a key reason why Kubernetes enables continuous deployment practices.

### Simulate a Bad Deployment

Deploy a non-existent image to see what happens when things go wrong:

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:broken
```

Check the status:

```bash
kubectl rollout status deployment/nginx-deploy
kubectl get pods
```

You'll see pods in `ImagePullBackOff` state - this means Kubernetes can't pull the image.

### Rollback to Previous Version

Revert to the last working version:

```bash
kubectl rollout undo deployment/nginx-deploy
```

Verify the rollback succeeded:

```bash
kubectl rollout status deployment/nginx-deploy
kubectl get pods
```

### View Rollout History

See all previous revisions:

```bash
kubectl rollout history deployment/nginx-deploy
```

Rollback to a specific revision if needed:

```bash
kubectl rollout undo deployment/nginx-deploy --to-revision=2
```

---

## 7. Labels and Selectors

> [!NOTE]
> **Instructor Note: Why Labels Are Kubernetes' Organization System**
>
> As your Kubernetes cluster grows, you might have hundreds or thousands of Pods, Services, and other resources. How do you organize and find them? Labels are Kubernetes' answer to this challenge. Think of labels like tags or hashtags - they're flexible key-value pairs you attach to resources to categorize them however makes sense for your organization. You might label resources by application (app=frontend), environment (env=production), version (version=v2), team (team=platform), or any other dimension that matters to you. The power comes from selectors, which let you query resources by their labels. For example, you can say "show me all production frontend pods" or "delete all resources from the old version". Deployments use selectors to know which Pods they manage - this is how a Deployment knows to recreate a Pod if it dies. Understanding labels is crucial because they're used throughout Kubernetes for organization, selection, and connecting resources together. They're also essential for advanced features like network policies and service meshes. This is a simple concept with profound implications for managing large-scale systems.

### Understanding Labels

Labels are key-value pairs attached to objects for organization and selection:

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
