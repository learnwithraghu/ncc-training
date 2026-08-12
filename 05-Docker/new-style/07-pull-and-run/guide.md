# 07: Pull from ECR and Run

**Time:** ~20 minutes

## Goal
Prove the push worked: remove the local Aether Launch image, pull it from ECR, run it, and confirm the company page.

Work only in this folder. It has its own `index.html` and `Dockerfile` if you need to rebuild, but the validation is the pull.

This is the last topic in the module.

## Commands to Teach

```bash
docker rmi aether-launch:1.0
docker pull <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
docker run -d --name aether-web -p 8080:80 <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
curl http://127.0.0.1:8080
```

- `docker rmi` deletes the local copy so you cannot cheat with the image you built earlier.
- `docker pull` downloads the image from ECR onto this EC2 host.
- `docker run` starts nginx from the pulled image.
- `curl` must still show **Aether Launch**.

## Guided Steps

1. Reuse the ECR URI from topic 06:

```bash
cd ~/ncc-training/05-Docker/new-style/07-pull-and-run
ECR_IMAGE_URI="<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0"
ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)
```

2. Remove local copies:

```bash
docker rm -f aether-web 2>/dev/null || true
docker rmi aether-launch:1.0 2>/dev/null || true
docker rmi "$ECR_IMAGE_URI" 2>/dev/null || true
docker images | grep aether || true
```

3. Login if needed, then pull:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker pull "$ECR_IMAGE_URI"
docker images
```

4. Run the pulled image and validate the page:

```bash
docker run -d --name aether-web -p 8080:80 "$ECR_IMAGE_URI"
curl -sS http://127.0.0.1:8080 | grep -o "Aether Launch" | head -n 1
```

Optional: open `http://<EC2_PUBLIC_IP>:8080` in a browser if port 8080 is open.

5. Clean up:

```bash
docker rm -f aether-web
```

This module ends here.

## Task

Delete local `aether-launch` tags. Pull the image from ECR, run it on `8080:80`, and curl until you see **Aether Launch**.

## Checkpoint
Why do we remove the local image before `docker pull`, and what does a successful page response prove about ECR?
