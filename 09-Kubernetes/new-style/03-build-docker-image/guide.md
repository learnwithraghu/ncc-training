# Topic 3: Build the Docker Image

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Install Docker on Ubuntu when it is missing, then validate it.
2. Bake the Orbital Relay page into `orbital-relay:1.0` with a two-line Dockerfile.
3. Run the image locally and prove the page with `curl`.
4. Log in to ECR, tag, and push using the AWS CLI from Topics 1–2.
5. Solve "I need a custom image in ECR before any Kubernetes Pod can pull it."

## Goal
Install Docker if needed, build the Orbital Relay image in this folder, and
push it to ECR as `orbital-relay:1.0`. Every later Kubernetes topic pulls
that image.

This folder is self-contained: `index.html`, `Dockerfile`, and
`.dockerignore` live here. You do not need files from a previous folder.

This lab is Ubuntu only (`NAME="Ubuntu"` in `/etc/os-release`). Install
Docker with `apt` (`docker.io`). Do not use Amazon Linux `dnf`.

## Commands to Teach

```bash
sudo apt-get install -y docker.io
docker build -t orbital-relay:1.0 .
docker run -d --name orbital-web -p 8080:80 orbital-relay:1.0
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker tag orbital-relay:1.0 <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/orbital-relay:1.0
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/orbital-relay:1.0
```

- `apt-get install docker.io` is the Ubuntu way to install the engine
  when it is not already present.
- `docker build -t orbital-relay:1.0 .` bakes `index.html` into nginx's
  html folder (see the two-line `Dockerfile`).
- `docker run` on port **8080** is the local proof before you push.
- ECR login uses a short-lived token from `aws ecr get-login-password`.
- `docker tag` / `docker push` upload layers to the `orbital-relay`
  repository in `us-east-1`.

## Guided Steps

1. Confirm you are on Ubuntu (`ID=ubuntu`, `NAME="Ubuntu"`):

```bash
cat /etc/os-release
```

2. Check Docker. If `docker info` fails, install and start it:

```bash
docker info
```

If that fails:

```bash
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
newgrp docker
docker --version
docker info
```

If `docker info` still asks for sudo, log out of SSH and log back in.

3. Smoke-test the daemon (optional if Docker was already working):

```bash
docker run hello-world
docker container prune -f
```

4. `cd` into this folder and build:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/03-build-docker-image
docker rm -f orbital-web 2>/dev/null || true
docker build -t orbital-relay:1.0 .
```

5. Run locally and prove the page:

```bash
docker run -d --name orbital-web -p 8080:80 orbital-relay:1.0
curl -sS http://127.0.0.1:8080 | grep -o "Orbital Relay"
curl -sS http://127.0.0.1:8080 | grep -o "Ground link v1"
```

6. Set the ECR URI from your account ID (from Topic 2's
   `get-caller-identity`):

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
ECR_IMAGE_URI="${ECR_REGISTRY}/orbital-relay:1.0"
echo "$ECR_IMAGE_URI"
```

7. Log in, tag, and push:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker tag orbital-relay:1.0 "$ECR_IMAGE_URI"
docker push "$ECR_IMAGE_URI"
```

8. Confirm ECR has the image:

```bash
aws ecr describe-images \
  --repository-name orbital-relay \
  --region us-east-1
```

Save `$ECR_REGISTRY` — every Pod/Deployment from Topic 4 onward uses:

```text
<ECR_REGISTRY>/orbital-relay:1.0
```

## Cleanup

Remove the local container so later builds stay clean. Keep the
`orbital-relay:1.0` image and the ECR copy:

```bash
docker rm -f orbital-web 2>/dev/null || true
docker container prune -f
docker ps
```

## Task

Install Docker if needed, build and run `orbital-relay:1.0` so
`curl http://127.0.0.1:8080` returns Orbital Relay, then push
`<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/orbital-relay:1.0` and
confirm it with `aws ecr describe-images`.

## Checkpoint

Why do we push the image to ECR instead of only keeping
`orbital-relay:1.0` on this Ubuntu host?

## What's Next?

This is good, but we still need:

1. A Kubernetes namespace so Orbital Relay does not collide with other
   workloads.
2. A Pod that pulls the image you just pushed, not a stock nginx page.
3. A way to reach that Pod from your laptop without cluster exposure yet.
4. Proof the baked `index.html` is what the cluster serves.
5. First workload on the cluster — **Topic 4: Run a Pod**.
