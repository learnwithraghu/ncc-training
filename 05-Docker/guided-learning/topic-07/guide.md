# Topic 7: Bind Mounts and App State

**Time:** 20 minutes

## Goal
Mount a host folder into the container and test file persistence.

## Commands to Use
```bash
mkdir -p ~/ncc-labs/day1/docker-data
docker run -d --name appdemo -p 5000:5000 -v ~/ncc-labs/day1/docker-data:/app/data your-image-name
curl -X POST http://localhost:5000/write -H 'Content-Type: application/json' -d '{"message":"hello from host mount"}'
docker rm -f appdemo
```

## Guided Steps
1. Create a host folder for container data.
2. Start the app with a bind mount.
3. Write data through the app endpoint.
4. Remove the container and explain why the host file remains.
5. Compare bind mounts with named volumes.

## Checkpoint
When would you choose a bind mount instead of a named volume?
