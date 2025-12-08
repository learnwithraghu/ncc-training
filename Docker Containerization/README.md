# Docker Containerization Tutorial

A comprehensive hands-on guide to Docker containerization using a Python Flask application.

## 📋 Table of Contents

1. [Hello World Python App](#1-hello-world-python-app)
2. [Building Docker Image](#2-building-docker-image)
3. [Working with Volumes](#3-working-with-volumes)
4. [Docker Networking](#4-docker-networking)
5. [Checking Logs](#5-checking-logs)
6. [Accessing Containers](#6-accessing-containers)
7. [Cleanup](#7-cleanup)
8. [Lab Challenge](#8-lab-challenge)

---

## 1. Hello World Python App

### Application Overview

Our Python application is a Flask web server with multiple endpoints:

- **`/`** - Main endpoint showing container info and visit count
- **`/health`** - Health check endpoint
- **`/info`** - Detailed container information
- **`/write`** - Write data to file (demonstrates volumes)
- **`/read`** - Read data from file (demonstrates volumes)

### File Structure

```
Docker Containerization/
├── app.py              # Python Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Docker build instructions
├── .dockerignore      # Files to exclude from build
└── README.md          # This file
```

### Testing Locally (Optional)

Before containerizing, you can test the app locally:

```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Test in another terminal
curl http://localhost:5000/
```

---

## 2. Building Docker Image

### Build the Image

```bash
# Build the Docker image
docker build -t hello-python-app:v1 .

# Verify the image was created
docker images | grep hello-python-app
```

**Explanation:**
- `-t hello-python-app:v1` - Tags the image with name and version
- `.` - Build context (current directory)

### Understanding the Build Process

The Dockerfile uses a multi-step approach:

1. **Base Image**: Uses `python:3.11-slim` for smaller size
2. **Working Directory**: Sets `/app` as the working directory
3. **Dependencies**: Copies and installs requirements first (caching optimization)
4. **Application Code**: Copies the Python application
5. **Environment Variables**: Sets default environment variables
6. **Port Exposure**: Exposes port 5000
7. **Health Check**: Configures container health monitoring
8. **Startup Command**: Defines how to run the application

### Inspect the Image

```bash
# View image details
docker inspect hello-python-app:v1

# View image history (layers)
docker history hello-python-app:v1

# Check image size
docker images hello-python-app:v1
```

### Run the Container

```bash
# Run container in detached mode
docker run -d -p 8080:5000 --name my-python-app hello-python-app:v1

# Verify container is running
docker ps
```

**Explanation:**
- `-d` - Run in detached mode (background)
- `-p 8080:5000` - Map host port 8080 to container port 5000
- `--name my-python-app` - Give container a friendly name

### Test the Application

```bash
# Test main endpoint
curl http://localhost:8080/

# Test health endpoint
curl http://localhost:8080/health

# Test info endpoint
curl http://localhost:8080/info
```

Expected response from main endpoint:
```json
{
  "message": "Hello from Docker!",
  "container_id": "abc123def456",
  "timestamp": "2025-12-08T13:00:00",
  "visit_count": 1,
  "environment": "production"
}
```

---

## 3. Working with Volumes

Volumes allow data to persist beyond container lifecycle and enable sharing data between containers.

### Stop Current Container

```bash
docker stop my-python-app
docker rm my-python-app
```

### Create a Named Volume

```bash
# Create a named volume
docker volume create app-data

# List volumes
docker volume ls

# Inspect volume
docker volume inspect app-data
```

### Run Container with Volume

```bash
# Run container with mounted volume
docker run -d \
  -p 8080:5000 \
  --name my-python-app \
  -v app-data:/app/data \
  hello-python-app:v1

# Verify volume is mounted
docker inspect my-python-app | grep -A 10 Mounts
```

**Explanation:**
- `-v app-data:/app/data` - Mounts volume `app-data` to `/app/data` in container

### Test Volume Persistence

```bash
# Write data to the volume
curl -X POST http://localhost:8080/write \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from volume!"}'

# Read the data
curl http://localhost:8080/read

# Stop and remove container
docker stop my-python-app
docker rm my-python-app

# Start a new container with same volume
docker run -d \
  -p 8080:5000 \
  --name my-python-app-v2 \
  -v app-data:/app/data \
  hello-python-app:v1

# Read data again - it should still be there!
curl http://localhost:8080/read
```

### Bind Mounts (Alternative to Volumes)

Bind mounts link a host directory to a container directory:

```bash
# Create a local data directory
mkdir -p ./data

# Run with bind mount
docker run -d \
  -p 8080:5000 \
  --name my-python-app \
  -v $(pwd)/data:/app/data \
  hello-python-app:v1

# Write data
curl -X POST http://localhost:8080/write \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from bind mount!"}'

# Check the file on your host
cat ./data/messages.txt
```

---

## 4. Docker Networking

Docker provides several networking modes for container communication.

### List Networks

```bash
# List all networks
docker network ls
```

Default networks:
- **bridge** - Default network for containers
- **host** - Container uses host's network stack
- **none** - No networking

### Create Custom Network

```bash
# Create a custom bridge network
docker network create my-app-network

# Inspect the network
docker network inspect my-app-network
```

### Run Containers on Custom Network

```bash
# Stop existing container
docker stop my-python-app
docker rm my-python-app

# Run container on custom network
docker run -d \
  --name my-python-app \
  --network my-app-network \
  -p 8080:5000 \
  hello-python-app:v1

# Run a second container on same network (for testing)
docker run -d \
  --name my-python-app-2 \
  --network my-app-network \
  hello-python-app:v1
```

### Test Container-to-Container Communication

```bash
# Access first container from second using container name
docker exec my-python-app-2 curl http://my-python-app:5000/

# This works because containers on same network can resolve each other by name
```

### Inspect Container Network Settings

```bash
# View network configuration
docker inspect my-python-app | grep -A 20 NetworkSettings

# View container IP address
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-python-app
```

### Connect/Disconnect Networks

```bash
# Connect container to additional network
docker network connect bridge my-python-app

# Disconnect from network
docker network disconnect bridge my-python-app
```

---

## 5. Checking Logs

Logs are essential for debugging and monitoring containerized applications.

### View Container Logs

```bash
# View all logs
docker logs my-python-app

# Follow logs in real-time (like tail -f)
docker logs -f my-python-app

# View last 50 lines
docker logs --tail 50 my-python-app

# View logs with timestamps
docker logs -t my-python-app

# View logs since specific time
docker logs --since 10m my-python-app  # Last 10 minutes
docker logs --since 2025-12-08T12:00:00 my-python-app  # Since specific time
```

### Generate Some Logs

```bash
# Make requests to generate logs
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/info

# View the logs
docker logs --tail 20 my-python-app
```

### Log Drivers

Docker supports different log drivers:

```bash
# Run container with json-file driver (default)
docker run -d \
  --name my-python-app \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  -p 8080:5000 \
  hello-python-app:v1
```

**Log Options:**
- `max-size` - Maximum size of log file before rotation
- `max-file` - Maximum number of log files to keep

---

## 6. Accessing Containers

### Execute Commands in Running Container

```bash
# Run a command in the container
docker exec my-python-app ls -la /app

# Check Python version
docker exec my-python-app python --version

# View environment variables
docker exec my-python-app env
```

### Interactive Shell Access

```bash
# Open interactive bash shell
docker exec -it my-python-app /bin/bash

# Once inside the container:
# - Navigate: cd /app
# - List files: ls -la
# - View processes: ps aux
# - Check network: netstat -tulpn
# - Exit: exit or Ctrl+D
```

**Explanation:**
- `-i` - Keep STDIN open (interactive)
- `-t` - Allocate a pseudo-TTY (terminal)

### Alternative: Use sh if bash not available

```bash
docker exec -it my-python-app /bin/sh
```

### Run One-off Commands

```bash
# Check disk usage
docker exec my-python-app df -h

# View running processes
docker exec my-python-app ps aux

# Test network connectivity
docker exec my-python-app ping -c 3 google.com

# Read application files
docker exec my-python-app cat /app/app.py
```

### Copy Files To/From Container

```bash
# Copy file from container to host
docker cp my-python-app:/app/app.py ./app-backup.py

# Copy file from host to container
docker cp ./new-config.txt my-python-app:/app/config.txt
```

---

## 7. Cleanup

Proper cleanup prevents disk space issues and keeps your Docker environment organized.

### Stop and Remove Containers

```bash
# Stop a running container
docker stop my-python-app

# Remove a stopped container
docker rm my-python-app

# Stop and remove in one command
docker rm -f my-python-app

# Remove all stopped containers
docker container prune -f
```

### Remove Images

```bash
# Remove specific image
docker rmi hello-python-app:v1

# Remove image by ID
docker rmi <image-id>

# Remove all unused images
docker image prune -a -f
```

### Remove Volumes

```bash
# Remove specific volume
docker volume rm app-data

# Remove all unused volumes
docker volume prune -f

# List volumes before removing
docker volume ls
```

### Remove Networks

```bash
# Remove specific network
docker network rm my-app-network

# Remove all unused networks
docker network prune -f
```

### Complete Cleanup

```bash
# Remove everything (containers, images, volumes, networks)
docker system prune -a --volumes -f

# View disk usage before cleanup
docker system df

# View disk usage after cleanup
docker system df
```

### Selective Cleanup

```bash
# Remove only containers older than 24 hours
docker container prune --filter "until=24h" -f

# Remove only images without tags (dangling)
docker image prune -f

# Remove only unused volumes
docker volume prune -f
```

---

## 8. Lab Challenge

### Challenge Description

Create a Docker image for a Python application and complete all the required tasks to demonstrate your understanding of Docker containerization.

### Requirements

1. ✅ **Build a Docker image** for the provided Python application
2. ✅ **Run the container** and verify it's working
3. ✅ **Add a volume** to persist data
4. ✅ **Create a custom network** and run the container on it
5. ✅ **View and follow logs** to monitor the application
6. ✅ **Access the container** using interactive shell
7. ✅ **Clean up** all resources when done

### Step-by-Step Solution

See [LAB_CHALLENGE.md](./LAB_CHALLENGE.md) for detailed instructions.

### Verification Checklist

- [ ] Docker image built successfully
- [ ] Container running and accessible on http://localhost:8080
- [ ] Volume mounted and data persists after container restart
- [ ] Custom network created and container connected
- [ ] Logs viewable and following in real-time
- [ ] Can access container with interactive shell
- [ ] All resources cleaned up properly

---

## 🔧 Troubleshooting

### Container Won't Start

```bash
# Check container status
docker ps -a

# View container logs
docker logs <container-name>

# Inspect container
docker inspect <container-name>
```

### Port Already in Use

```bash
# Find what's using the port
lsof -i :8080  # macOS/Linux
netstat -ano | findstr :8080  # Windows

# Use a different port
docker run -p 8081:5000 ...
```

### Volume Data Not Persisting

```bash
# Verify volume is mounted
docker inspect <container-name> | grep Mounts -A 10

# Check volume exists
docker volume ls

# Inspect volume
docker volume inspect <volume-name>
```

### Cannot Access Container

```bash
# Check if container is running
docker ps

# Check port mapping
docker port <container-name>

# Test from inside container
docker exec <container-name> curl http://localhost:5000
```

---

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Networking](https://docs.docker.com/network/)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)

---

## 🎯 Key Takeaways

1. **Containerization** packages applications with all dependencies
2. **Volumes** enable data persistence and sharing
3. **Networks** allow container-to-container communication
4. **Logs** are essential for debugging and monitoring
5. **Interactive access** helps troubleshoot running containers
6. **Cleanup** prevents resource waste and disk space issues

---

**Happy Dockerizing! 🐳**
