# Step 07: Deploy to Local Kubernetes

## Goal
Build the `document-search` image locally and deploy it to an existing local Kubernetes cluster, creating a dedicated namespace and using the locally built image.

## Time
Approximately **25 minutes**.

## What You Will Do

1. Verify a local Kubernetes cluster is running and reachable.
2. Create the `document-search` namespace.
3. Build the Docker image locally from this folder.
4. Load the image into the local cluster if needed (kind / minikube / k3d).
5. Apply the namespace, Deployment, and Service manifests.
6. Verify the Pod is running and healthy.
7. Port-forward the Service and test the app in a browser.
8. Clean up the Kubernetes resources.

## Prerequisites

- Completion of [06-eks-deploy](../06-eks-deploy/) OR the earlier Dockerize steps.
- A local Kubernetes cluster already running (for example: Docker Desktop Kubernetes, minikube, kind, k3d, or a similar tool).
- `kubectl` and `docker` installed and on your PATH.

## Quick Checks

Verify your cluster is reachable:

```bash
kubectl cluster-info
kubectl get nodes
```

You should see cluster information and at least one ready node.

## Build the Image Locally

From this folder, build the image with a local tag:

```bash
docker build -t document-search:latest .
```

Confirm the image exists:

```bash
docker images | grep document-search
```

## Load the Image into the Cluster (if needed)

Some local clusters cannot see images built by your host Docker daemon. Load the image when required:

- **kind:**

  ```bash
  kind load docker-image document-search:latest --name <your-cluster-name>
  ```

- **minikube:**

  ```bash
  minikube image load document-search:latest
  ```

- **k3d:**

  ```bash
  k3d image import document-search:latest --cluster <your-cluster-name>
  ```

- **Docker Desktop Kubernetes:** the host daemon is shared with the cluster, so no extra load step is needed.

## Create the Namespace

The manifests use the `document-search` namespace. Create it before applying:

```bash
kubectl apply -f k8s/namespace.yaml
```

Verify:

```bash
kubectl get namespace document-search
```

## Deploy

Apply the Deployment and Service:

```bash
kubectl apply -f k8s/
```

Expected output:

```text
namespace/document-search unchanged
deployment.apps/document-search created
service/document-search created
```

## Verify the Pod

Wait for the Pod to be ready in the namespace:

```bash
kubectl get pods -n document-search --watch
```

Once it shows `1/1` ready, check the logs:

```bash
kubectl logs -n document-search -l app=document-search --tail=50
```

You should see Streamlit start and listen on `0.0.0.0:8501`.

If the Pod status is `ImagePullBackOff`, the cluster cannot see the local image. Re-check the load step for your cluster type and confirm `imagePullPolicy: Never` is set in the Deployment.

## Access the App Locally

Port-forward the Service from the `document-search` namespace:

```bash
kubectl port-forward -n document-search svc/document-search 8501:8501
```

Open your browser at:

```text
http://localhost:8501
```

> Keep the terminal with `kubectl port-forward` open while you use the app.

## Test the End-to-End Flow

1. Upload one of the sample PDFs from [sample-documents/](sample-documents/).
2. Click **Process**.
3. Review the extracted structured data.
4. Download the resulting `.xlsx` file.

## Health Check

While `kubectl port-forward` is running:

```bash
curl -f http://localhost:8501/_stcore/health
```

A `200 OK` response means the Streamlit backend is healthy.

## Cleanup

Stop the port-forward with `Ctrl+C`, then delete the Kubernetes resources:

```bash
kubectl delete -f k8s/
```

Optional: remove the local Docker image:

```bash
docker rmi document-search:latest
```

## Checkpoint

1. Why do we set `imagePullPolicy: Never` in the Deployment?
2. What is the purpose of the `document-search` namespace?
3. When do you need to run `kind load docker-image` or `minikube image load`?
4. How can you tell that the Pod is using the locally built image?

## Congratulations

You built the Document Search image locally and deployed it to a local Kubernetes cluster with a dedicated namespace, accessible through `kubectl port-forward`.
