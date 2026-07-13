# Topic 10: Healthchecks and Restart Behavior

**Time:** 20 minutes

## Goal
Use container health checks to report application status.

## Commands to Use
```bash
docker run -d --name appdemo -p 5000:5000 your-image-name
docker inspect --format='{{.State.Health.Status}}' appdemo
docker ps --filter health=healthy
docker rm -f appdemo
```

## Guided Steps
1. Start the sample app container.
2. Inspect the health status.
3. Show how Docker reports healthy and unhealthy containers.
4. Explain the health check in the Dockerfile.
5. Connect health checks to production monitoring.

## Checkpoint
What is the purpose of a health check in a container image?
