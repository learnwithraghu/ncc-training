# Solution: Volumes and Networking

## Commands
```bash
docker build -t ncc-app ./application
docker run -d -p 8080:8080 -v $(pwd)/data:/data ncc-app
docker logs <container-id>
docker inspect <container-id>
```

## Notes
- A bind mount keeps host data visible to the container.
- `docker inspect` shows configuration details, including networking and mounts.