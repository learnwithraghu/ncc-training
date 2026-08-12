# Guide 2: Launch Jenkins from an ECR Pull-Through Cache

## Goal
Keep the same ECS cluster and service, but point the task definition at an Amazon ECR pull-through cache URI instead of Docker Hub. ECS still runs `jenkins/jenkins:lts-jdk17`; ECR caches the image in your account.

## Time
Approximately **25 minutes**.

## What You Brought Forward

Guide 1 is running (or you can recreate it):

- Cluster: `jenkins-cluster`
- Task family: `jenkins`
- Service: `jenkins-service`
- Security group: `jenkins-ecs-sg`

You also need a Docker Hub username and access token. AWS requires those credentials for a Docker Hub pull-through cache rule. Create the token at Docker Hub → Account Settings → Personal access tokens (read permission is enough).

Updating the service replaces the Fargate task. Because this lab uses ephemeral storage, Jenkins starts empty again. Unlock it from CloudWatch Logs the same way as Guide 1.

---

## Step 1: Create the Pull-Through Cache Rule

ECR → Private registry → **Pull through cache** → Add rule.

1. **Source registry:** Docker Hub (`registry-1.docker.io`)
2. **Authentication:** Docker Hub requires a Secrets Manager secret.
   - Choose **Create a new AWS secret** if the wizard offers it, or create the secret first in Secrets Manager
   - Secret name must start with `ecr-pullthroughcache/`
   - Keys: `username` (Docker Hub username) and `accessToken` (Docker Hub access token)
   - Use the default `aws/secretsmanager` encryption key
3. **Amazon ECR repository prefix:** `docker-hub`
4. Create the rule

Do not create an empty Jenkins repository by hand. The first ECS pull creates `docker-hub/jenkins/jenkins` in ECR.

## Step 2: Allow the Execution Role to Import the Image

`AmazonECSTaskExecutionRolePolicy` can pull from ECR. The **first** pull-through also needs permission to create the cached repository.

IAM → Roles → `ecsTaskExecutionRole` → Add permissions → Create inline policy.

- Service: Elastic Container Registry
- Actions: `CreateRepository`, `BatchImportUpstreamImage`
- Resources: all, or limit to `docker-hub/*` in this region
- Name: `ECRPullThroughCache`
- Create policy

Do not paste AWS access keys into the task. The execution role pulls the image.

## Step 3: Copy the ECR Image URI

Stay in the same region as the cluster. Open ECR and copy your registry hostname from any repository page, or build the URI from the account and region shown in the Console:

```text
<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/docker-hub/jenkins/jenkins:lts-jdk17
```

Example:

```text
123456789012.dkr.ecr.us-east-1.amazonaws.com/docker-hub/jenkins/jenkins:lts-jdk17
```

Paste the account ID and region from the Console. Do not invent them. The path after the registry is `docker-hub` (your prefix) plus `jenkins/jenkins:lts-jdk17` (the upstream image).

The image may not exist in ECR yet. That is expected. ECS pull creates it.

## Step 4: New Task Definition Revision

ECS → Task definitions → `jenkins` → Create new revision.

Keep Guide 1 settings:

- Fargate · Linux/X86_64
- CPU **1 vCPU** · Memory **2 GB**
- Execution role: `ecsTaskExecutionRole`
- Container name: `jenkins`
- Port: **8080**
- Log group: `/ecs/jenkins`
- No volumes

Change only the container image to the ECR URI from Step 3.

Create. The family stays `jenkins`. This is a new revision.

## Step 5: Update the Service

Cluster `jenkins-cluster` → service `jenkins-service` → Update.

- Task definition: `jenkins` latest revision
- Force new deployment: on
- Keep public subnets, `jenkins-ecs-sg`, and **Public IP: Turned on**

Update and wait for the new task to reach **Running**. The old task is replaced.

## Step 6: Verify

1. Open the new task → confirm the image URI starts with `<ACCOUNT_ID>.dkr.ecr.` and includes `docker-hub/jenkins/jenkins:lts-jdk17`
2. Copy the new **Public IP** (it likely changed)
3. Browser: `http://<TASK_PUBLIC_IP>:8080`
4. Unlock Jenkins from CloudWatch Logs again
5. ECR → Repositories: `docker-hub/jenkins/jenkins` now exists with tag `lts-jdk17`

First start can take longer than Guide 1. ECR is pulling from Docker Hub and caching the layers.

## When to Use ECR Instead of Docker Hub

| Public Docker Hub in the task definition | ECR pull-through URI in the task definition |
|------------------------------------------|---------------------------------------------|
| Fastest lab path | Same-region pulls after the first cache |
| Subject to Docker Hub rate limits on every task start | Later starts can use the cached ECR copy |
| No ECR setup | Matches org policy that workloads pull only from ECR |
| Guide 1 | Same pattern as other AWS workloads that store images in ECR |

---

## Troubleshooting

| Symptom | Check |
|---------|--------|
| Cannot pull image | Exact ECR URI; pull-through prefix `docker-hub`; execution role has `CreateRepository` and `BatchImportUpstreamImage` |
| Pull-through auth error | Secret name starts with `ecr-pullthroughcache/`; keys are `username` and `accessToken`; Docker Hub token is valid |
| Timeout in browser | New task public IP; SG 8080 from **My IP** |
| Jenkins setup wizard again | Expected: ephemeral disk, new task |
| Empty ECR repo list | Wait until the task has pulled; then refresh Repositories |

## Checkpoint

1. Which field in the task definition changed between Guide 1 and Guide 2?
2. Why does Docker Hub pull-through need a Secrets Manager secret?
3. Why did Jenkins ask for a new admin password after the service update?
4. When would you prefer the ECR URI over `jenkins/jenkins:lts-jdk17`?

## Cleanup

Stop charges when you are done:

1. ECS → `jenkins-cluster` → `jenkins-service` → Update desired count to **0**, or delete the service
2. Delete cluster `jenkins-cluster`
3. Delete task definition revisions for family `jenkins` (deregister)
4. ECR → delete repository `docker-hub/jenkins/jenkins` and the pull-through cache rule
5. Secrets Manager → delete `ecr-pullthroughcache/...`
6. EC2 → delete security group `jenkins-ecs-sg`
7. CloudWatch → delete log group `/ecs/jenkins`
8. IAM → remove the `ECRPullThroughCache` inline policy if you added it only for this lab
