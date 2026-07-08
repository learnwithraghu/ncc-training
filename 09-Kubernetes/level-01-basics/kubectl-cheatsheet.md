# kubectl Cheat Sheet - Level 1 Basics

## Cluster Information

```bash
# Display cluster info
kubectl cluster-info

# Display cluster info with detailed output
kubectl cluster-info dump

# Get cluster nodes
kubectl get nodes

# Get nodes with more details
kubectl get nodes -o wide

# Describe a specific node
kubectl describe node <node-name>

# Check component status (deprecated but useful)
kubectl get componentstatuses
kubectl get cs
```

## Namespaces

```bash
# List all namespaces
kubectl get namespaces
kubectl get ns

# Create a namespace
kubectl create namespace <name>

# Create namespace from YAML
kubectl apply -f namespace.yaml

# Describe a namespace
kubectl describe namespace <name>

# Delete a namespace (deletes all resources in it!)
kubectl delete namespace <name>

# Get resources in a specific namespace
kubectl get pods -n <namespace>
kubectl get all -n <namespace>

# Get resources across all namespaces
kubectl get pods --all-namespaces
kubectl get pods -A
```

## Context Management

```bash
# Show current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch to a different context
kubectl config use-context <context-name>

# Set default namespace for current context
kubectl config set-context --current --namespace=<namespace>

# View kubeconfig
kubectl config view

# View kubeconfig for current context only
kubectl config view --minify
```

## Viewing Resources

```bash
# Get all resources in current namespace
kubectl get all

# Get all resources in all namespaces
kubectl get all -A

# Get specific resource types
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get replicasets
kubectl get configmaps
kubectl get secrets

# Get resources with short names
kubectl get po        # pods
kubectl get svc       # services
kubectl get deploy    # deployments
kubectl get rs        # replicasets
kubectl get cm        # configmaps
```

## Output Formats

```bash
# Wide output (more columns)
kubectl get pods -o wide

# YAML format
kubectl get pods -o yaml
kubectl get pod <pod-name> -o yaml

# JSON format
kubectl get pods -o json
kubectl get pod <pod-name> -o json

# Custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# JSONPath (extract specific fields)
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{.items[*].status.podIP}'

# Name only
kubectl get pods -o name
```

## Describe and Explain

```bash
# Describe a resource (detailed info)
kubectl describe node <node-name>
kubectl describe namespace <namespace-name>
kubectl describe pod <pod-name>
kubectl describe pod <pod-name> -n <namespace>

# Explain resource structure (built-in docs)
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.containers
kubectl explain deployment
kubectl explain service
```

## API Resources

```bash
# List all API resources
kubectl api-resources

# List API resources with short names
kubectl api-resources -o name

# List namespaced resources
kubectl api-resources --namespaced=true

# List non-namespaced resources
kubectl api-resources --namespaced=false

# List API versions
kubectl api-versions
```

## Help and Documentation

```bash
# General help
kubectl --help
kubectl -h

# Help for specific command
kubectl get --help
kubectl create --help
kubectl apply --help

# Explain any resource
kubectl explain <resource>
kubectl explain <resource>.<field>
kubectl explain <resource>.<field>.<subfield>

# Examples:
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.containers
kubectl explain deployment.spec.replicas
```

## Useful Flags

```bash
# Specify namespace
-n <namespace>
--namespace=<namespace>

# All namespaces
--all-namespaces
-A

# Output format
-o wide
-o yaml
-o json
-o name
-o custom-columns=...
-o jsonpath=...

# Show labels
--show-labels

# Label selector
-l key=value
--selector=key=value

# Field selector
--field-selector=status.phase=Running

# Watch for changes
--watch
-w

# No headers in output
--no-headers

# Sort by
--sort-by=.metadata.name
--sort-by=.metadata.creationTimestamp
```

## Quick Examples

```bash
# Get all pods in kube-system namespace
kubectl get pods -n kube-system

# Get all resources across all namespaces
kubectl get all -A

# Describe a node
kubectl describe node minikube

# View pod in YAML format
kubectl get pod <pod-name> -o yaml

# Get pod names only
kubectl get pods -o name

# Watch pods (updates in real-time)
kubectl get pods --watch

# Get pods with labels
kubectl get pods --show-labels

# Get pods with specific label
kubectl get pods -l app=nginx

# Get running pods only
kubectl get pods --field-selector=status.phase=Running

# Create namespace
kubectl create namespace dev

# Set default namespace
kubectl config set-context --current --namespace=dev

# Switch back to default namespace
kubectl config set-context --current --namespace=default
```

## Common Patterns

```bash
# Check cluster health
kubectl get nodes
kubectl get pods -n kube-system
kubectl cluster-info

# Explore a new cluster
kubectl get namespaces
kubectl get all -A
kubectl get nodes -o wide

# Find resource short names
kubectl api-resources | grep <resource>

# Get detailed info about a resource type
kubectl explain <resource> --recursive

# Save resource to file
kubectl get pod <pod-name> -o yaml > pod.yaml

# Check what you can do (permissions)
kubectl auth can-i create deployments
kubectl auth can-i delete pods
kubectl auth can-i '*' '*'
```

## Tips and Tricks

### 1. Use Short Names
```bash
kubectl get po        # instead of kubectl get pods
kubectl get svc       # instead of kubectl get services
kubectl get deploy    # instead of kubectl get deployments
kubectl get ns        # instead of kubectl get namespaces
kubectl get cm        # instead of kubectl get configmaps
```

### 2. Set Aliases
Add to your `.bashrc` or `.zshrc`:
```bash
alias k=kubectl
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kga='kubectl get all'
alias kgaa='kubectl get all -A'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
```

### 3. Use kubectl Autocomplete
```bash
# For bash
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# For zsh
source <(kubectl completion zsh)
echo "source <(kubectl completion zsh)" >> ~/.zshrc
```

### 4. Use -o wide for More Info
```bash
kubectl get pods -o wide
kubectl get nodes -o wide
kubectl get services -o wide
```

### 5. Use --watch to Monitor Changes
```bash
kubectl get pods --watch
kubectl get deployments --watch
```

### 6. Use kubectl explain Instead of Googling
```bash
kubectl explain pod
kubectl explain deployment.spec
kubectl explain service.spec.type
```

## Common Errors and Solutions

### Error: "The connection to the server was refused"
**Solution:** Cluster is not running or kubectl is misconfigured
```bash
# Check cluster status (Minikube example)
minikube status
minikube start

# Verify kubeconfig
kubectl config view
```

### Error: "No resources found"
**Solution:** Check namespace or resources don't exist
```bash
# Check all namespaces
kubectl get pods -A

# Verify current namespace
kubectl config view --minify | grep namespace
```

### Error: "Error from server (Forbidden)"
**Solution:** Insufficient permissions
```bash
# Check permissions
kubectl auth can-i get pods
kubectl auth can-i create deployments
```

## Next Steps

Once you're comfortable with these basics:
1. Practice creating and managing namespaces
2. Explore different output formats
3. Use kubectl explain to learn about resources
4. Set up aliases for efficiency
5. Move on to Level 2: Pods & Deployments

---

*Keep this cheat sheet handy as you progress through the Kubernetes module!*
