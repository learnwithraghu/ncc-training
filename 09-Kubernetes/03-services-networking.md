# Level 3: Services & Networking

**Expose applications and configure networking in Kubernetes**

## Learning Objectives

By the end of this level, you will:

- ✅ Understand Kubernetes networking model
- ✅ Create and manage Services (ClusterIP, NodePort, LoadBalancer)
- ✅ Implement service discovery and DNS
- ✅ Configure Ingress for HTTP/HTTPS routing
- ✅ Use port forwarding for debugging
- ✅ Apply network policies for security

**Estimated Time:** 60 minutes

---

## 1. Kubernetes Networking Basics

### The Networking Model

Kubernetes networking has four key requirements:

1. **Pods can communicate** with all other pods without NAT
2. **Nodes can communicate** with all pods without NAT
3. **Each pod gets its own IP** address
4. **Containers in a pod** share the network namespace (localhost)

### Pod-to-Pod Communication

Create two pods and test communication:

```bash
# Create first pod
kubectl run pod1 --image=nginx

# Create second pod
kubectl run pod2 --image=busybox --command -- sleep 3600

# Get pod1's IP
POD1_IP=$(kubectl get pod pod1 -o jsonpath='{.status.podIP}')
echo $POD1_IP

# Test connectivity from pod2
kubectl exec pod2 -- wget -qO- http://$POD1_IP
```

---

## 2. Services - ClusterIP

### Why Services?

- Pods are ephemeral (their IPs change)
- Need stable endpoint for accessing pods
- Load balancing across multiple pods
- Service discovery via DNS

### Create a ClusterIP Service

**ClusterIP** is the default service type (internal only):

```bash
# Create deployment
kubectl create deployment web --image=nginx --replicas=3

# Expose as ClusterIP service
kubectl expose deployment web --port=80 --target-port=80

# View service
kubectl get services
kubectl get svc web
```

### Service Details

```bash
kubectl describe service web
```

**Key information:**
- **Type**: ClusterIP
- **IP**: Cluster-internal IP
- **Port**: Service port
- **TargetPort**: Container port
- **Endpoints**: Pod IPs

### Test Service

```bash
# Get service IP
SVC_IP=$(kubectl get svc web -o jsonpath='{.spec.clusterIP}')

# Test from a pod
kubectl run test --image=busybox --rm -it -- wget -qO- http://$SVC_IP
```

### Service from YAML

```bash
kubectl apply -f level-03-services-networking/clusterip-service.yaml
kubectl get svc
```

---

## 3. Service Discovery and DNS

### DNS in Kubernetes

Kubernetes creates DNS records for services:

**Format**: `<service-name>.<namespace>.svc.cluster.local`

### Test DNS Resolution

```bash
# Create a test pod
kubectl run dns-test --image=busybox --rm -it -- sh

# Inside the pod, test DNS:
nslookup web
nslookup web.default
nslookup web.default.svc.cluster.local

# Test HTTP access by name
wget -qO- http://web
wget -qO- http://web.default.svc.cluster.local

# Exit
exit
```

### Cross-Namespace Communication

```bash
# Create namespace and service
kubectl create namespace other
kubectl create deployment app --image=nginx -n other
kubectl expose deployment app --port=80 -n other

# Access from default namespace
kubectl run test --image=busybox --rm -it -- wget -qO- http://app.other.svc.cluster.local
```

---

## 4. NodePort Services

### Expose Service Externally

**NodePort** exposes service on each node's IP at a static port (30000-32767):

```bash
# Create NodePort service
kubectl expose deployment web --name=web-nodeport --type=NodePort --port=80

# View service
kubectl get svc web-nodeport
```

### Access NodePort Service

```bash
# Get node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Get NodePort
NODE_PORT=$(kubectl get svc web-nodeport -o jsonpath='{.spec.ports[0].nodePort}')

echo "Access at: http://$NODE_IP:$NODE_PORT"

# Test (if accessible)
curl http://$NODE_IP:$NODE_PORT
```

### NodePort from YAML

```bash
kubectl apply -f level-03-services-networking/nodeport-service.yaml
kubectl get svc
```

---

## 5. LoadBalancer Services

### Cloud Load Balancer

**LoadBalancer** creates an external load balancer (cloud providers only):

```bash
kubectl expose deployment web --name=web-lb --type=LoadBalancer --port=80
```

**Note**: On Minikube/Kind, external IP stays `<pending>`. On cloud (GKE, EKS, AKS), you get a real external IP.

### Minikube LoadBalancer

If using Minikube:

```bash
# In a separate terminal
minikube tunnel

# Check service
kubectl get svc web-lb
```

### LoadBalancer from YAML

```bash
kubectl apply -f level-03-services-networking/loadbalancer-service.yaml
kubectl get svc
```

---

## 6. Port Forwarding

### Debug Services Locally

Port forwarding creates a tunnel from your local machine to a pod or service:

```bash
# Forward to a pod
kubectl port-forward pod/web-<pod-id> 8080:80

# Forward to a service
kubectl port-forward service/web 8080:80

# Forward to a deployment
kubectl port-forward deployment/web 8080:80
```

Access in browser: `http://localhost:8080`

**Use cases:**
- Debug services without exposing them
- Access databases temporarily
- Test applications locally

---

## 7. Endpoints

### Understanding Endpoints

Endpoints connect services to pods:

```bash
# View endpoints
kubectl get endpoints
kubectl get ep

# Describe service endpoints
kubectl describe endpoints web
```

### Manual Endpoints

You can create services without selectors and manually manage endpoints (advanced use case for external services).

---

## 8. Ingress

### What is Ingress?

**Ingress** provides HTTP/HTTPS routing to services:
- Host-based routing (`app1.example.com`, `app2.example.com`)
- Path-based routing (`example.com/app1`, `example.com/app2`)
- TLS/SSL termination
- Single entry point for multiple services

### Enable Ingress Controller

**Minikube:**
```bash
minikube addons enable ingress
```

**Kind/Other:**
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
```

### Create Ingress

```bash
# Create services
kubectl create deployment app1 --image=nginx
kubectl expose deployment app1 --port=80

kubectl create deployment app2 --image=httpd
kubectl expose deployment app2 --port=80

# Apply ingress
kubectl apply -f level-03-services-networking/ingress-example.yaml

# View ingress
kubectl get ingress
kubectl describe ingress my-ingress
```

### Test Ingress

```bash
# Get ingress IP
kubectl get ingress

# Add to /etc/hosts (if testing locally)
# <ingress-ip> app1.local app2.local

# Test
curl http://app1.local
curl http://app2.local
```

---

## 9. Network Policies

### Secure Pod Communication

Network policies control traffic between pods:

```bash
# Create namespaces
kubectl create namespace frontend
kubectl create namespace backend

# Deploy apps
kubectl create deployment web --image=nginx -n frontend
kubectl create deployment api --image=nginx -n backend

# Apply network policy
kubectl apply -f level-03-services-networking/network-policy.yaml

# View policies
kubectl get networkpolicies -A
kubectl get netpol -A
```

### Test Network Policy

```bash
# Before policy: frontend can access backend
kubectl run test -n frontend --image=busybox --rm -it -- wget -qO- http://api.backend

# After policy: access denied (if policy blocks it)
```

**Note**: Network policies require a CNI plugin that supports them (Calico, Cilium, Weave Net).

---

## 10. Service Types Comparison

| Type | Use Case | Accessibility | External IP |
|------|----------|---------------|-------------|
| **ClusterIP** | Internal services | Cluster only | No |
| **NodePort** | Development, testing | Node IP + Port | No |
| **LoadBalancer** | Production (cloud) | External LB | Yes |
| **ExternalName** | External services | DNS CNAME | N/A |

---

## Hands-On Practice

### Exercise 1: Service Discovery

1. Create a deployment with 3 replicas
2. Expose as ClusterIP service
3. Test DNS resolution from another pod
4. Access service by name

### Exercise 2: NodePort Service

1. Create a NodePort service
2. Find the node IP and port
3. Access the service externally
4. Scale the deployment and verify load balancing

### Exercise 3: Ingress Routing

1. Create two different deployments
2. Expose both as ClusterIP services
3. Create an Ingress with path-based routing
4. Test both paths

### Exercise 4: Network Policies

1. Create two namespaces
2. Deploy pods in each
3. Test connectivity
4. Apply network policy to restrict access
5. Verify policy enforcement

### Exercise 5: Run Demo Script

```bash
bash level-03-services-networking/service-discovery-demo.sh
```

---

## Common Issues

### Issue: Service has no endpoints

**Cause**: Selector doesn't match any pods.

**Solution:**
```bash
kubectl get endpoints <service-name>
kubectl describe service <service-name>
# Check selector matches pod labels
```

### Issue: Cannot access NodePort

**Cause**: Firewall, wrong IP/port.

**Solution:**
```bash
kubectl get svc
kubectl get nodes -o wide
# Verify node IP and NodePort
```

### Issue: Ingress not working

**Cause**: Ingress controller not installed.

**Solution:**
```bash
kubectl get pods -n ingress-nginx
# Install ingress controller if missing
```

---

## Key Takeaways

✅ **Services provide stable endpoints** for pods  
✅ **ClusterIP for internal**, NodePort for external, LoadBalancer for cloud  
✅ **DNS enables service discovery** by name  
✅ **Ingress routes HTTP/HTTPS** traffic  
✅ **Network policies secure** pod communication  
✅ **Port forwarding helps debugging**  

---

## Next Steps

Proceed to [04-storage-config.md](./04-storage-config.md) to learn about persistent storage and configuration management.

---

*Level 3 Complete! 🎉*
