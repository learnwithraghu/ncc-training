# Demo Infra Requirement

## Infra Needed

- Amazon Linux 2023 EC2 lab host (for AWS CLI / Docker install and image build)
- Instructor-provided AWS access keys (this module uses `aws configure`)
- ECR repository named `orbital-relay` in `us-east-1`
- Kubernetes cluster access
- kubectl configured to the target cluster
- Cluster nodes able to pull from the `orbital-relay` ECR repository
- Permission to create namespaces, pods, deployments, services,
  configmaps, and secrets
- No Ingress controller, storage class, or metrics-server required for the
  core topics; `kubectl top` in Topic 10 is optional and needs
  metrics-server if you want to demo it

## Quick Validation

```bash
cat /etc/os-release
aws --version
aws sts get-caller-identity
aws ecr describe-repositories --repository-names orbital-relay --region us-east-1
docker info
kubectl version --client
kubectl cluster-info
kubectl get nodes
kubectl auth can-i create deployments
kubectl auth can-i create secrets
```

## Instructor Lab Runner

```bash
cd ~/ncc-training/09-Kubernetes/new-style/helpers
bash run-k8s-lab.sh
```

`--ecr-image-uri` is optional. If omitted, the script uses the account
from `aws sts get-caller-identity` and the `orbital-relay` repository in
`us-east-1`.

It installs Docker and AWS CLI v2 if missing, validates credentials and
the ECR repository, builds and pushes `:1.0` and `:2.0`, then applies
every Kubernetes topic's manifests into a scratch namespace
(`orbital-relay-lab`), waits for each rollout, curls Orbital Relay through
a port-forward, exercises the rollback (topic 7) and probe-failure
(topic 10) scenarios, then deletes the namespace. Exit code 0 means the
lab is ready to teach.
