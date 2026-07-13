# Topic 6: Volumes and Data Persistence

**Time:** 20 minutes

## Goal
Store data outside the container so it survives restarts.

## Commands to Use
```bash
docker volume create appdata
docker run -d --name appdemo -p 5000:5000 -v appdata:/app/data your-image-name
docker volume inspect appdata
docker rm -f appdemo
docker volume rm appdata
```

## Guided Steps
1. Create a named volume.
2. Attach it to `/app/data`.
3. Inspect the volume details.
4. Remove the container and explain why the volume still exists.
5. Talk through how this supports persistent app data.

## Checkpoint
Why is a Docker volume better than storing data only in the container filesystem?
