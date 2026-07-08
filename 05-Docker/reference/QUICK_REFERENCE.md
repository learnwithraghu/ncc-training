# Quick Reference - Docker Commands

## Image Commands

```bash
# Build image
docker build -t <image-name>:<tag> .

# List images
docker images

# Remove image
docker rmi <image-name>

# Inspect image
docker inspect <image-name>

# View image history
docker history <image-name>

# Tag image
docker tag <source-image> <target-image>:<tag>

# Remove unused images
docker image prune -a
```

## Container Commands

```bash
# Run container
docker run -d -p <host-port>:<container-port> --name <name> <image>

# List running containers
docker ps

# List all containers
docker ps -a

# Stop container
docker stop <container-name>

# Start container
docker start <container-name>

# Restart container
docker restart <container-name>

# Remove container
docker rm <container-name>

# Force remove running container
docker rm -f <container-name>

# Remove all stopped containers
docker container prune
```

## Volume Commands

```bash
# Create volume
docker volume create <volume-name>

# List volumes
docker volume ls

# Inspect volume
docker volume inspect <volume-name>

# Remove volume
docker volume rm <volume-name>

# Remove unused volumes
docker volume prune

# Run with volume
docker run -v <volume-name>:<container-path> <image>

# Run with bind mount
docker run -v <host-path>:<container-path> <image>
```

## Network Commands

```bash
# Create network
docker network create <network-name>

# List networks
docker network ls

# Inspect network
docker network inspect <network-name>

# Connect container to network
docker network connect <network-name> <container-name>

# Disconnect container from network
docker network disconnect <network-name> <container-name>

# Remove network
docker network rm <network-name>

# Remove unused networks
docker network prune
```

## Log Commands

```bash
# View logs
docker logs <container-name>

# Follow logs
docker logs -f <container-name>

# Last N lines
docker logs --tail <N> <container-name>

# Logs with timestamps
docker logs -t <container-name>

# Logs since time
docker logs --since <time> <container-name>
# Examples: 10m, 1h, 2025-12-08T12:00:00
```

## Exec Commands

```bash
# Execute command
docker exec <container-name> <command>

# Interactive shell
docker exec -it <container-name> /bin/bash

# Run as specific user
docker exec -u <user> <container-name> <command>
```

## Copy Commands

```bash
# Copy from container to host
docker cp <container-name>:<container-path> <host-path>

# Copy from host to container
docker cp <host-path> <container-name>:<container-path>
```

## System Commands

```bash
# View disk usage
docker system df

# Remove all unused resources
docker system prune

# Remove all unused resources including volumes
docker system prune --volumes

# Remove everything
docker system prune -a --volumes

# View real-time stats
docker stats

# View system info
docker info
```

## Inspect Commands

```bash
# Inspect container
docker inspect <container-name>

# Get specific field
docker inspect -f '{{.State.Status}}' <container-name>

# Get IP address
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-name>

# Get port mapping
docker port <container-name>
```

## Common Patterns

### Run Container with All Options
```bash
docker run -d \
  --name my-app \
  -p 8080:5000 \
  -v app-data:/app/data \
  --network my-network \
  -e ENV_VAR=value \
  --memory="256m" \
  --cpus="0.5" \
  --restart unless-stopped \
  my-image:v1
```

### Debug Container
```bash
# Check if running
docker ps | grep <container-name>

# View logs
docker logs --tail 50 <container-name>

# Check resource usage
docker stats <container-name>

# Inspect configuration
docker inspect <container-name>

# Access shell
docker exec -it <container-name> /bin/bash
```

### Complete Cleanup
```bash
# Stop all containers
docker stop $(docker ps -q)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)

# Remove all volumes
docker volume rm $(docker volume ls -q)

# Remove all networks
docker network rm $(docker network ls -q)

# Or use system prune
docker system prune -a --volumes -f
```

## Environment Variables

```bash
# Single variable
docker run -e VAR_NAME=value <image>

# Multiple variables
docker run -e VAR1=value1 -e VAR2=value2 <image>

# From file
docker run --env-file .env <image>
```

## Health Checks

```bash
# Check health status
docker inspect --format='{{.State.Health.Status}}' <container-name>

# View health logs
docker inspect --format='{{json .State.Health}}' <container-name>
```

## Resource Limits

```bash
# Memory limit
docker run --memory="256m" <image>

# CPU limit
docker run --cpus="0.5" <image>

# Both
docker run --memory="256m" --cpus="0.5" <image>
```

## Restart Policies

```bash
# No restart
docker run --restart no <image>

# Always restart
docker run --restart always <image>

# Restart on failure
docker run --restart on-failure <image>

# Restart unless stopped
docker run --restart unless-stopped <image>
```
