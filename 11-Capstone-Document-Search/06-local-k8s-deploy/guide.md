# Step 06: Deploy to Local Kubernetes

## Goal
Build the `document-search` image, push it to the public Docker Hub repository `learnwithraghu/ncc-workshop`, and deploy it to an existing local Kubernetes cluster using the public image.

## Time
Approximately **25 minutes**.

## Start Here

Open this step folder before you run any commands:

```bash
cd 11-Capstone-Document-Search/06-local-k8s-deploy
```

Bring your `.env` file forward so the Docker image can bake in the same app settings used in earlier steps:

```bash
cp ../.env_example .env
```

If you already completed an earlier step and have a filled `.env`, you can copy that file instead.

## What You Will Do

1. Verify a local Kubernetes cluster is running and reachable.
2. Create the `document-search` namespace.
3. Build the Docker image from this folder.
4. Push the image to Docker Hub (`learnwithraghu/ncc-workshop`).
5. Apply the namespace, Deployment, and Service manifests.
6. Verify the Pod is running and healthy.
7. Port-forward the Service and test the app in a browser.
8. Clean up the Kubernetes resources.

## Prerequisites

- Completion of [05-ecs-deploy](../05-ecs-deploy/) OR the earlier Dockerize steps.
- A k3s cluster already running and reachable with `kubectl`.
- `kubectl` and `docker` installed and on your PATH.

If Docker is not installed yet on Ubuntu, run this once before you continue:

```bash
bash helpers/install-docker.sh
```

This script installs Docker Engine and adds your user to the `docker` group.

## Quick Checks

Verify your cluster is reachable:

```bash
kubectl cluster-info
kubectl get nodes
```

You should see cluster information and at least one ready node.

## Build and Push the Image

From this folder, build the image with the Docker Hub repository tag. Make sure `.env` is present in this folder first, because the Dockerfile copies it into the image:

```bash
docker build -t learnwithraghu/ncc-workshop:latest .
```

Push the image to Docker Hub so the Kubernetes cluster can pull it:

```bash
docker push learnwithraghu/ncc-workshop:latest
```

Confirm the image exists locally:

```bash
docker images | grep ncc-workshop
```

> The cluster must be able to reach Docker Hub. The Deployment uses `imagePullPolicy: Always` so Kubernetes always fetches the published image.

## Create the Namespace

The manifests in `k8s/` use the `document-search` namespace. Create it before applying the rest of the manifests:

```bash
kubectl apply -f k8s/namespace.yaml
```

Verify:

```bash
kubectl get namespace document-search
```

## Deploy

Apply the Deployment and Service from this folder:

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

If the Pod status is `ImagePullBackOff`, the cluster cannot pull the public image. Check that:

- The image tag in `k8s/deployment.yaml` matches the tag you pushed (`learnwithraghu/ncc-workshop:latest`).
- The cluster has outbound internet access to Docker Hub.
- You are logged in to Docker Hub and the repository is public or the cluster has valid credentials.

## Access the App Locally

Port-forward the Service from the `document-search` namespace while you stay in this step folder:

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
docker rmi learnwithraghu/ncc-workshop:latest
```

## Checkpoint

1. Why do we set `imagePullPolicy: Always` in the Deployment?
2. What is the purpose of the `document-search` namespace?
3. What happens if the Pod status shows `ImagePullBackOff`?
4. How can you tell which container image a Pod is running?

## Congratulations

You built the Document Search image locally and deployed it to a local Kubernetes cluster with a dedicated namespace, accessible through `kubectl port-forward`.

## Next Step

Go to **[07-helm-deploy](../07-helm-deploy/)**.
