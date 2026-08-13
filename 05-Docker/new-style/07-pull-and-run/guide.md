# 07: Pull from ECR and Run (optional extra)

**Time:** ~20 minutes

Skip this topic if you already deleted the local image, pulled from ECR, and ran it in [06-push-to-ecr](../06-push-to-ecr/guide.md).

## Goal
Practice the pull path from this folder: remove any local Aether Launch image, pull from ECR, run it, and confirm the company page.

Work only in this folder. The image should already be in ECR from topic 06.

## Commands to Teach

```bash
docker rm -f aether-web 2>/dev/null || true
docker rmi aether-launch:1.0
docker pull 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker run -d --name aether-web -p 8080:80 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
curl http://127.0.0.1:8080
docker rm -f aether-web
```

- `docker rmi` deletes the local copy so you cannot cheat with an image you built earlier.
- `docker pull` downloads the image from ECR onto this EC2 host.
- `docker run` starts nginx from the pulled image.
- `curl` must still show **Aether Launch**.

## Guided Steps

1. Reuse the ECR URI from topic 06:

```bash
cd ~/ncc-training/05-Docker/new-style/07-pull-and-run
ECR_IMAGE_URI="851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0"
```

2. Remove local copies. Delete the container first, or `docker rmi` fails:

```bash
docker rm -f aether-web 2>/dev/null || true
docker rmi aether-launch:1.0 2>/dev/null || true
docker rmi "$ECR_IMAGE_URI" 2>/dev/null || true
docker images
```

3. Login if needed, then pull and run:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 851725341232.dkr.ecr.us-east-1.amazonaws.com

docker pull "$ECR_IMAGE_URI"
docker run -d --name aether-web -p 8080:80 "$ECR_IMAGE_URI"
curl -sS http://127.0.0.1:8080 | grep -o "Aether Launch" | head -n 1
```

Optional: open `http://<EC2_PUBLIC_IP>:8080` if port 8080 is open.

## Cleanup

```bash
docker rm -f aether-web 2>/dev/null || true
docker ps -a
```

If `docker rmi` said **image is being used by a container**, or `docker run` said **name already in use** / **port is already allocated**, remove the container first and retry.

## Task

Delete local `aether-launch` tags. Pull the image from ECR, run it on `8080:80`, and curl until you see **Aether Launch**. Then `docker rm -f aether-web`.

## Checkpoint
Why do we remove the local image before `docker pull`, and what does a successful page response prove about ECR?
