# 06: Push to ECR, Pull, and Run

**Time:** ~20 minutes

## Goal
Build `aether-launch:1.0` in this folder, push it to ECR, delete the local image, then pull it back and run it.

The IAM role is already attached to this EC2 instance.

ECR image: `851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0`

Work only in this folder. It has its own `index.html` and `Dockerfile`.

## Commands to Teach

```bash
docker build -t aether-launch:1.0 .
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 851725341232.dkr.ecr.us-east-1.amazonaws.com
docker tag aether-launch:1.0 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker push 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker rmi aether-launch:1.0
docker rmi 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker pull 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker run -d --name aether-web -p 8080:80 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
curl http://127.0.0.1:8080
```

- The instance role is already attached, so `aws ecr get-login-password` works. You do not set up credentials.
- `docker tag` gives the local image the ECR name. `docker push` uploads it.
- `docker rmi` deletes the local copies so the next run cannot use the image you just built.
- `docker pull` downloads from ECR. `docker run` proves that pulled image still serves **Aether Launch**.

## Guided Steps

1. Build from this folder:

```bash
cd ~/ncc-training/05-Docker/new-style/06-push-to-ecr
docker rm -f aether-web 2>/dev/null || true
docker build -t aether-launch:1.0 .
```

2. Login, tag, and push:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 851725341232.dkr.ecr.us-east-1.amazonaws.com

docker tag aether-launch:1.0 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker push 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
```

3. Remove the local image so you cannot run the copy you just built:

```bash
docker rm -f aether-web 2>/dev/null || true
docker rmi aether-launch:1.0
docker rmi 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker images
```

The Aether Launch image should be gone locally.

4. Pull from ECR and run:

```bash
docker pull 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
docker run -d --name aether-web -p 8080:80 851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0
curl -sS http://127.0.0.1:8080 | grep -o "Aether Launch" | head -n 1
```

Optional: open `http://<EC2_PUBLIC_IP>:8080` if port 8080 is open.

## Cleanup

```bash
docker rm -f aether-web 2>/dev/null || true
docker ps -a
```

If `docker rmi` said **image is being used by a container**, remove the container first, then retry `docker rmi`.

## Task

From this folder, build `aether-launch:1.0`, push it to `851725341232.dkr.ecr.us-east-1.amazonaws.com/raghu-ncc:1.0`, delete the local image, pull it back, run it on `8080:80`, and curl until you see **Aether Launch**.

## Checkpoint
Why do we delete the local image before `docker pull`?
