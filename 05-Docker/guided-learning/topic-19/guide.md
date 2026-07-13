# Topic 19: Full App Workflow

**Time:** 20 minutes

## Goal
Walk through the sample app from source to running container.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:demo .
docker run -d --name appdemo -p 5000:5000 -v appdata:/app/data ncc-training-app:demo
curl http://localhost:5000/
curl http://localhost:5000/health
docker rm -f appdemo
```

## Guided Steps
1. Build the app image.
2. Run the container.
3. Check the root endpoint.
4. Check the health endpoint.
5. Explain how the source, image, and container relate to each other.

## Checkpoint
What are the three main stages in the app workflow: source, image, and what else?
