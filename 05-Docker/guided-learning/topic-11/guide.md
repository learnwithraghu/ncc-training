# Topic 11: Docker Networking Basics

**Time:** 20 minutes

## Goal
Understand container networking and basic communication.

## Commands to Use
```bash
docker network ls
docker network create training-net
docker run -d --name appdemo --network training-net your-image-name
docker network inspect training-net
docker network rm training-net
```

## Guided Steps
1. List the default Docker networks.
2. Create a custom bridge network.
3. Run a container on that network.
4. Inspect the network to see connected containers.
5. Explain why custom networks help multi-container apps.

## Checkpoint
Why would you create a custom network instead of using the default bridge network?
