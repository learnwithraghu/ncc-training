# Topic 18: Troubleshooting Containers

**Time:** 20 minutes

## Goal
Use Docker commands to debug common container issues.

## Commands to Use
```bash
docker ps -a
docker logs appdemo
docker inspect appdemo
docker exec -it appdemo sh
docker rm -f appdemo
```

## Guided Steps
1. Check the container state.
2. Read the logs.
3. Inspect the container config.
4. Open a shell inside the container.
5. Explain the sequence you would use to debug a failure.

## Checkpoint
Which command would you use first if a container exits immediately?
