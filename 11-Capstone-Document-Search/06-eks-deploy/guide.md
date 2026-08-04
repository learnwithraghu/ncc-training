# Step 06: Deploy to EKS

## Goal
Deploy the `document-search` image from ECR to an existing Amazon EKS cluster using Kubernetes manifests, then access the Streamlit UI locally with `kubectl port-forward`.

## Time
Approximately **30 minutes**.

## What You Will Do

1. Verify your EKS cluster is reachable with `kubectl`.
2. Update the image URI in `k8s/deployment.yaml` to point to your ECR image.
3. Apply the Kubernetes Deployment and Service.
4. Verify the Pod is running and healthy.
5. Port-forward the Service to your laptop and open the app in a browser.
6. Upload a sample PDF, process it, and download the Excel result.
7. Clean up the Kubernetes resources.

## Prerequisites

- Completion of [05-ecs-deploy](../05-ecs-deploy/).
- The same `document-search:latest` image already pushed to Amazon ECR.
- An existing EKS cluster and a `kubeconfig` that points to it.
- `kubectl` and the AWS CLI installed and configured.
- Worker nodes (or managed node group / Fargate profile) with an IAM role that allows pulling images from ECR.

## Quick Checks

Set your ECR registry URI and cluster name as environment variables to avoid typos:

```bash
export AWS_REGION=us-east-1
export ECR_REGISTRY=<your-account-id>.dkr.ecr.${AWS_REGION}.amazonaws.com
export EKS_CLUSTER_NAME=<your-cluster-name>
```

Verify EKS access:

```bash
aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
kubectl cluster-info
kubectl get nodes
```

You should see cluster info and a list of ready nodes.

## Update the Manifest

Open [k8s/deployment.yaml](k8s/deployment.yaml) and replace the placeholder image:

```yaml
image: <YOUR_ECR_REGISTRY>/document-search:latest
```

with your actual ECR URI, for example:

```yaml
image: 123456789012.dkr.ecr.us-east-1.amazonaws.com/document-search:latest
```

Leave [k8s/service.yaml](k8s/service.yaml) as-is — it exposes the Deployment on a ClusterIP service at port `8501`.

## Deploy

Apply both manifests from this folder:

```bash
kubectl apply -f k8s/
```

Expected output:

```text
deployment.apps/document-search created
service/document-search created
```

## Verify the Pod

Wait for the Pod to be ready:

```bash
kubectl get pods -l app=document-search --watch
```

Once it shows `1/1` ready, check the logs:

```bash
kubectl logs -l app=document-search --tail=50
```

You should see Streamlit start and listen on `0.0.0.0:8501`.

## Access the App Locally

Because the Service is `ClusterIP`, reach it from your laptop with port-forwarding:

```bash
kubectl port-forward svc/document-search 8501:8501
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

Optional: delete the image from ECR and rotate the API key that was baked into the image.

## Checkpoint

1. Why must the image URI in `k8s/deployment.yaml` point to ECR?
2. What type of Service is used, and why do we use `kubectl port-forward`?
3. What does the readiness probe check?
4. Which IAM permission does the worker node need to pull the image?

## Congratulations

You have deployed the Document Search application to Amazon EKS, verified the Pod, and accessed the Streamlit UI through Kubernetes port-forwarding.

## Next Step

Go to **[07-local-k8s-deploy](../07-local-k8s-deploy/)**.
