# Topic 3: Run Containers and Publish Ports

**Time:** 20 minutes

## Goal
Start a container and make it reachable from the host.

## Commands to Use
```bash
docker run -d --name webtest -p 8080:80 nginx
docker ps
docker port webtest
docker stop webtest
docker rm webtest
```

## Guided Steps
1. Run a simple web container in detached mode.
2. Map container port 80 to host port 8080.
3. Check the running container list.
4. Inspect the published port mapping.
5. Stop and remove the container when finished.

## Checkpoint
What does `-p 8080:80` mean in a Docker run command?
