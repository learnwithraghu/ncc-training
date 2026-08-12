# 03: Docker Run and Ports

**Time:** ~20 minutes

## Goal
Run the image you built, publish a host port, and prove the Flask app answers on EC2.

## Commands to Teach

```bash
docker run -d --name appdemo -p 5000:5000 ncc-training-app:1.0
docker ps
curl http://127.0.0.1:5000/health
docker stop appdemo && docker rm appdemo
```

- `docker run -d -p 5000:5000` starts the container in the background and maps host port 5000 to container port 5000.
- `docker ps` lists running containers so you can see the name, image, and ports.
- `curl /health` is the check that the process inside the container is actually serving HTTP.
- `docker stop` then `docker rm` clean up so the next topic can reuse the name and port.

## Guided Steps

1. If the image is missing, build it first. Every run starts from a build:

```bash
cd ~/ncc-training/05-Docker/application
docker build -t ncc-training-app:1.0 .
```

2. Start the container in detached mode and publish port 5000:

```bash
docker run -d --name appdemo -p 5000:5000 ncc-training-app:1.0
```

`-p 5000:5000` means host:container. Traffic to the EC2 instance on port 5000 reaches the Flask app inside the container.

3. Confirm it is running:

```bash
docker ps
```

4. Hit the app from the same EC2 instance:

```bash
curl http://127.0.0.1:5000/
curl http://127.0.0.1:5000/health
```

`/` returns JSON with a hello message. `/health` should return a healthy status.

5. Stop and remove the container so the name `appdemo` and port 5000 are free:

```bash
docker stop appdemo
docker rm appdemo
```

## Task

Build `ncc-training-app:1.0` if you do not already have it. Run it with a published port, curl both `/` and `/health`, then stop and remove the container. If `docker run` fails because the name or port is in use, find the old container with `docker ps -a` and clean it up yourself.

## Checkpoint
What does `-p 5000:5000` map, and why do you curl `127.0.0.1` from the EC2 instance instead of from your laptop?
