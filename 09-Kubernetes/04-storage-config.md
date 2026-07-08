# Level 4: Storage & Configuration

**Manage persistent data and application configuration**

## Learning Objectives

By the end of this level, you will:

- ✅ Understand Kubernetes storage concepts
- ✅ Create and use Volumes
- ✅ Manage PersistentVolumes and PersistentVolumeClaims
- ✅ Use ConfigMaps for configuration
- ✅ Manage Secrets securely
- ✅ Configure environment variables
- ✅ Mount configuration as files

**Estimated Time:** 60 minutes

---

## 1. Volumes Overview

### Why Volumes?

Containers are ephemeral—their filesystems disappear when they're destroyed. **Volumes** provide persistent storage.

### Volume Types

- **emptyDir**: Temporary storage, deleted with pod
- **hostPath**: Mount from host node (avoid in production)
- **configMap**: Mount ConfigMap as files
- **secret**: Mount Secret as files
- **persistentVolumeClaim**: Request persistent storage

---

## 2. ConfigMaps

### What are ConfigMaps?

**ConfigMaps** store non-sensitive configuration data as key-value pairs.

### Create ConfigMap (Imperative)

```bash
# From literal values
kubectl create configmap app-config \
  --from-literal=ENV=production \
  --from-literal=LOG_LEVEL=info \
  --from-literal=DB_HOST=mysql.default.svc.cluster.local

# View ConfigMap
kubectl get configmaps
kubectl get cm

# Describe
kubectl describe configmap app-config

# View as YAML
kubectl get configmap app-config -o yaml
```

### Create ConfigMap from File

```bash
# Create a config file
echo "database_url=mysql://db:3306" > app.properties
echo "cache_enabled=true" >> app.properties

# Create ConfigMap from file
kubectl create configmap app-config-file --from-file=app.properties

# View
kubectl describe configmap app-config-file
```

### Create ConfigMap from YAML

```bash
kubectl apply -f level-04-storage-config/configmap-demo.yaml
kubectl get cm
```

### Use ConfigMap as Environment Variables

```bash
kubectl apply -f level-04-storage-config/pod-with-configmap-env.yaml
kubectl get pods

# Check environment variables
kubectl exec configmap-env-pod -- env | grep -E 'ENV|LOG_LEVEL|DB_HOST'
```

### Mount ConfigMap as Volume

```bash
kubectl apply -f level-04-storage-config/pod-with-configmap-volume.yaml

# Check mounted files
kubectl exec configmap-volume-pod -- ls /etc/config
kubectl exec configmap-volume-pod -- cat /etc/config/ENV
kubectl exec configmap-volume-pod -- cat /etc/config/LOG_LEVEL
```

---

## 3. Secrets

### What are Secrets?

**Secrets** store sensitive data (passwords, tokens, keys). Similar to ConfigMaps but for sensitive information.

**Important**: Secrets are base64 encoded, NOT encrypted by default!

### Create Secret (Imperative)

```bash
# From literal values
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=mypassword123

# View Secrets
kubectl get secrets

# Describe (data is hidden)
kubectl describe secret db-secret

# View as YAML (data is base64 encoded)
kubectl get secret db-secret -o yaml
```

### Decode Secret

```bash
# Get base64 encoded password
kubectl get secret db-secret -o jsonpath='{.data.password}'

# Decode it
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 --decode
echo ""
```

### Create Secret from File

```bash
# Create files
echo -n 'admin' > username.txt
echo -n 'mypassword123' > password.txt

# Create secret from files
kubectl create secret generic db-secret-file \
  --from-file=username=username.txt \
  --from-file=password=password.txt

# Cleanup files
rm username.txt password.txt
```

### Create Secret from YAML

```bash
kubectl apply -f level-04-storage-config/secret-demo.yaml
kubectl get secrets
```

**Note**: In YAML, values must be base64 encoded:
```bash
echo -n 'mypassword' | base64
```

### Use Secret as Environment Variables

```bash
kubectl apply -f level-04-storage-config/pod-with-secret-env.yaml

# Check (be careful in production!)
kubectl exec secret-env-pod -- env | grep -E 'DB_USER|DB_PASS'
```

### Mount Secret as Volume

```bash
kubectl apply -f level-04-storage-config/pod-with-secret-volume.yaml

# Check mounted files
kubectl exec secret-volume-pod -- ls /etc/secrets
kubectl exec secret-volume-pod -- cat /etc/secrets/username
kubectl exec secret-volume-pod -- cat /etc/secrets/password
```

---

## 4. Persistent Volumes (PV)

### Understanding PV and PVC

**PersistentVolume (PV)**: Cluster-level storage resource (admin creates)  
**PersistentVolumeClaim (PVC)**: Request for storage (user creates)  
**StorageClass**: Defines storage types and enables dynamic provisioning

### Create PersistentVolume

```bash
kubectl apply -f level-04-storage-config/pv-example.yaml
kubectl get pv
kubectl describe pv my-pv
```

**PV States:**
- **Available**: Ready to be claimed
- **Bound**: Bound to a PVC
- **Released**: PVC deleted, but not yet reclaimed
- **Failed**: Automatic reclamation failed

---

## 5. Persistent Volume Claims (PVC)

### Create PVC

```bash
kubectl apply -f level-04-storage-config/pvc-example.yaml
kubectl get pvc
kubectl describe pvc my-pvc
```

**PVC States:**
- **Pending**: Waiting for PV to bind
- **Bound**: Bound to a PV
- **Lost**: PV no longer exists

### Check Binding

```bash
# PVC should be Bound
kubectl get pvc my-pvc

# PV should be Bound to the PVC
kubectl get pv my-pv
```

---

## 6. Using PVC in Pods

### Mount PVC as Volume

```bash
kubectl apply -f level-04-storage-config/pod-with-pvc.yaml
kubectl get pods

# Write data to persistent volume
kubectl exec pvc-pod -- sh -c 'echo "Hello from PVC!" > /data/hello.txt'

# Read data
kubectl exec pvc-pod -- cat /data/hello.txt

# Delete pod
kubectl delete pod pvc-pod

# Recreate pod
kubectl apply -f level-04-storage-config/pod-with-pvc.yaml
kubectl wait --for=condition=ready pod/pvc-pod --timeout=60s

# Data persists!
kubectl exec pvc-pod -- cat /data/hello.txt
```

---

## 7. StorageClasses

### View StorageClasses

```bash
kubectl get storageclasses
kubectl get sc
```

### Dynamic Provisioning

With StorageClasses, PVs are created automatically when you create a PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  storageClassName: standard  # Uses StorageClass
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

---

## 8. Access Modes

**ReadWriteOnce (RWO)**: Single node read-write  
**ReadOnlyMany (ROX)**: Multiple nodes read-only  
**ReadWriteMany (RWX)**: Multiple nodes read-write

```bash
# Check PV access modes
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage,ACCESS:.spec.accessModes
```

---

## 9. Hands-On Practice

### Exercise 1: ConfigMaps

1. Create a ConfigMap with app settings
2. Create a pod that uses it as environment variables
3. Create another pod that mounts it as files
4. Verify configuration is accessible

### Exercise 2: Secrets

1. Create a Secret with database credentials
2. Create a pod that uses it as environment variables
3. Decode the secret manually
4. Mount secret as files in a pod

### Exercise 3: Persistent Storage

1. Create a PersistentVolume
2. Create a PersistentVolumeClaim
3. Create a pod that uses the PVC
4. Write data to the volume
5. Delete and recreate the pod
6. Verify data persists

### Exercise 4: Run Demo Script

```bash
bash level-04-storage-config/storage-demo.sh
```

---

## 10. Best Practices

### ConfigMaps
✅ Use for non-sensitive configuration  
✅ Keep configurations small (< 1MB)  
✅ Version your ConfigMaps  
✅ Use meaningful names  

### Secrets
✅ Never commit secrets to Git  
✅ Use RBAC to restrict access  
✅ Consider external secret management (Vault, AWS Secrets Manager)  
✅ Encrypt secrets at rest in etcd  
✅ Rotate secrets regularly  

### Persistent Volumes
✅ Use StorageClasses for dynamic provisioning  
✅ Set appropriate access modes  
✅ Define resource requests and limits  
✅ Implement backup strategies  
✅ Monitor storage usage  

---

## Common Issues

### Issue: PVC stuck in Pending

**Cause**: No PV matches the PVC requirements.

**Solution:**
```bash
kubectl describe pvc <pvc-name>
# Check: storage size, access mode, storage class
```

### Issue: ConfigMap changes not reflected

**Cause**: Mounted ConfigMaps update eventually (not immediately).

**Solution:**
- Wait a minute for kubelet to sync
- Or restart the pod
- Or use a sidecar to watch for changes

### Issue: Cannot access secret data

**Cause**: Incorrect base64 encoding or permissions.

**Solution:**
```bash
# Verify encoding
kubectl get secret <name> -o yaml
echo '<base64-string>' | base64 --decode
```

---

## Key Takeaways

✅ **ConfigMaps for configuration**, Secrets for sensitive data  
✅ **PVs and PVCs** provide persistent storage  
✅ **StorageClasses** enable dynamic provisioning  
✅ **Mount as env vars or files** depending on use case  
✅ **Secrets are base64 encoded**, not encrypted  
✅ **Data persists** across pod restarts with PVCs  

---

## Next Steps

Proceed to [05-advanced.md](./05-advanced.md) for advanced Kubernetes topics including StatefulSets, Jobs, CronJobs, and more.

---

*Level 4 Complete! 🎉*
