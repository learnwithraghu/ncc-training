# Step 07: Deploy with Helm to Local Kubernetes

## Goal
Build the `document-search` image locally and deploy it to an existing local Kubernetes cluster using Helm, creating a dedicated namespace through the chart.

## Time
Approximately **30 minutes**.

## What You Will Do

1. Verify a local Kubernetes cluster is running and reachable.
2. Build the Docker image locally from this folder.
3. Load the image into the local cluster if needed (kind / minikube / k3d).
4. Install the Helm chart, which creates the namespace, Deployment, and Service.
5. Verify the Helm release and Pod are healthy.
6. Port-forward the Service and test the app in a browser.
7. Clean up the Helm release.

## Prerequisites

- Completion of [06-local-k8s-deploy](../06-local-k8s-deploy/).
- A local Kubernetes cluster already running (for example: Docker Desktop Kubernetes, minikube, kind, k3d, or a similar tool).
- `kubectl`, `docker`, and `helm` installed and on your PATH.

## Quick Checks

Verify your cluster is reachable:

```bash
kubectl cluster-info
kubectl get nodes
```

Verify Helm is installed:

```bash
helm version
```

You should see cluster information, ready nodes, and Helm version output.

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

## Inspect the Helm Chart

The chart lives in [helm/document-search/](helm/document-search/):

- `Chart.yaml` — chart metadata.
- `values.yaml` — configurable values: image, namespace, service, resources, probes.
- `templates/namespace.yaml` — creates the `document-search` namespace.
- `templates/deployment.yaml` — deploys the app.
- `templates/service.yaml` — exposes the app on ClusterIP port 8501.
- `templates/_helpers.tpl` — reusable named templates.

Notice that `values.yaml` sets:

```yaml
image:
  repository: document-search
  tag: latest
  pullPolicy: Never
```

This matches the classroom approach of using a locally built image without a registry.

## Deploy with Helm

Install the chart from this folder:

```bash
helm install document-search helm/document-search/
```

Expected output shows the release name and a `STATUS: deployed` line.

If you need to make changes later, upgrade the release:

```bash
helm upgrade document-search helm/document-search/
```

## Verify the Release and Pod

List Helm releases:

```bash
helm list
```

Wait for the Pod to be ready:

```bash
kubectl get pods -n document-search --watch
```

Once it shows `1/1` ready, check the logs:

```bash
kubectl logs -n document-search -l app.kubernetes.io/name=document-search --tail=50
```

You should see Streamlit start and listen on `0.0.0.0:8501`.

If the Pod status is `ImagePullBackOff`, the cluster cannot see the local image. Re-check the load step for your cluster type and confirm `pullPolicy: Never` is set in `values.yaml`.

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

## Templated Render (Optional)

Preview what Helm will send to Kubernetes without applying it:

```bash
helm template document-search helm/document-search/
```

This is useful for debugging templated values before install.

## Cleanup

Stop the port-forward with `Ctrl+C`, then uninstall the release:

```bash
helm uninstall document-search
```

Helm removes the Deployment and Service, but the namespace may remain if it was created outside the chart. If needed, delete it manually:

```bash
kubectl delete namespace document-search
```

Optional: remove the local Docker image:

```bash
docker rmi document-search:latest
```

## Checkpoint

1. Why does `values.yaml` set `pullPolicy: Never`?
2. What Helm command creates the namespace, Deployment, and Service in one step?
3. How is `helm template` different from `helm install`?
4. What would you change in `values.yaml` to scale the app to two replicas?

## Congratulations

You built the Document Search image locally and deployed it to a local Kubernetes cluster using Helm, with a dedicated namespace and templated manifests.

## Next Step

Go to **[08-eks-deploy](../08-eks-deploy/)**.
