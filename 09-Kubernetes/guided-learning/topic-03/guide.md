# Topic 3: kubectl Resource Discovery

**Time:** 20 minutes

## Goal
Use kubectl to inspect resources and discover object fields with confidence.

## Commands to Use
```bash
kubectl get all
kubectl get pods -A
kubectl get services -A
kubectl describe node $(kubectl get nodes -o name | head -n1 | cut -d/ -f2)
kubectl explain pod
kubectl explain deployment.spec
```

## Guided Steps
1. List common resources in the default namespace and across all namespaces.
2. Use describe output to understand runtime state and recent events.
3. Use kubectl explain to inspect object schemas before writing YAML.
4. Compare wide output with describe details.

## Checkpoint
When should you use kubectl explain instead of kubectl describe?
