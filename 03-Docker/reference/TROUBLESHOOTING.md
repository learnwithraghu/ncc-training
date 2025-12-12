# Docker Containerization - Troubleshooting Guide

## Common Issues and Solutions

### 1. Container Won't Start

#### Symptoms
- Container exits immediately after starting
- `docker ps` doesn't show the container
- Container status shows "Exited"

#### Diagnosis
```bash
# Check container status
docker ps -a | grep <container-name>

# View logs
docker logs <container-name>

# Inspect container
docker inspect <container-name>
```

#### Common Causes & Solutions

**Application Error**
```bash
# Check logs for Python errors
docker logs <container-name>

# Common fix: Missing dependencies
# Rebuild image after updating requirements.txt
docker build -t hello-python-app:v1 .
```

**Port Already in Use**
```bash
# Check what's using the port
lsof -i :8080  # macOS/Linux
netstat -ano | findstr :8080  # Windows

# Solution: Use different port
docker run -p 8081:5000 --name my-python-app hello-python-app:v1
```

**Insufficient Resources**
```bash
# Check Docker resources
docker info

# Solution: Increase Docker resources in Docker Desktop settings
```

---

### 2. Cannot Access Application

#### Symptoms
- `curl http://localhost:8080` fails
- Connection refused or timeout

#### Diagnosis
```bash
# Check if container is running
docker ps

# Check port mapping
docker port <container-name>

# Test from inside container
docker exec <container-name> curl http://localhost:5000
```

#### Solutions

**Wrong Port Mapping**
```bash
# Verify port mapping
docker inspect <container-name> | grep PortBindings -A 5

# Fix: Remove and recreate with correct ports
docker rm -f <container-name>
docker run -d -p 8080:5000 --name my-python-app hello-python-app:v1
```

**Firewall Blocking**
```bash
# macOS: Check firewall settings
# System Preferences > Security & Privacy > Firewall

# Linux: Check iptables
sudo iptables -L

# Windows: Check Windows Firewall
```

**Application Not Listening on 0.0.0.0**
```python
# In app.py, ensure:
app.run(host='0.0.0.0', port=5000)
# NOT
app.run(host='localhost', port=5000)
```

---

### 3. Volume Data Not Persisting

#### Symptoms
- Data disappears after container restart
- Volume appears empty

#### Diagnosis
```bash
# Check if volume is mounted
docker inspect <container-name> | grep Mounts -A 10

# Check volume exists
docker volume ls

# Inspect volume
docker volume inspect <volume-name>
```

#### Solutions

**Volume Not Mounted**
```bash
# Fix: Recreate container with volume
docker rm -f <container-name>
docker run -d -p 8080:5000 -v app-data:/app/data --name my-python-app hello-python-app:v1
```

**Wrong Mount Path**
```bash
# Verify application writes to /app/data
docker exec <container-name> ls -la /app/data

# Check app.py for correct path
docker exec <container-name> cat app.py | grep data_dir
```

**Permission Issues**
```bash
# Check directory permissions
docker exec <container-name> ls -la /app

# Fix: Ensure directory is writable
docker exec <container-name> chmod 777 /app/data
```

---

### 4. Network Issues

#### Symptoms
- Containers can't communicate
- DNS resolution fails

#### Diagnosis
```bash
# Check container network
docker inspect <container-name> | grep NetworkSettings -A 20

# List networks
docker network ls

# Inspect network
docker network inspect <network-name>
```

#### Solutions

**Containers on Different Networks**
```bash
# Check which network each container is on
docker inspect <container-1> | grep NetworkMode
docker inspect <container-2> | grep NetworkMode

# Fix: Connect to same network
docker network connect <network-name> <container-name>
```

**DNS Not Working**
```bash
# Test DNS resolution
docker exec <container-name> nslookup <other-container-name>

# Fix: Use custom network (not default bridge)
docker network create my-network
docker run --network my-network ...
```

---

### 5. Build Failures

#### Symptoms
- `docker build` fails
- Build hangs or times out

#### Diagnosis
```bash
# Build with verbose output
docker build --progress=plain -t hello-python-app:v1 .

# Check build context size
du -sh .
```

#### Solutions

**Large Build Context**
```bash
# Add files to .dockerignore
echo "*.log" >> .dockerignore
echo "data/" >> .dockerignore

# Verify .dockerignore is working
docker build --no-cache -t hello-python-app:v1 .
```

**Network Issues During Build**
```bash
# Retry with different DNS
docker build --dns 8.8.8.8 -t hello-python-app:v1 .

# Use cache from previous build
docker build -t hello-python-app:v1 .
```

**Dependency Installation Fails**
```bash
# Update requirements.txt with specific versions
# Instead of: Flask
# Use: Flask==3.0.0

# Clear pip cache
docker build --no-cache -t hello-python-app:v1 .
```

---

### 6. Permission Denied Errors

#### Symptoms
- "Permission denied" when accessing files
- Cannot write to volume

#### Solutions

**Volume Permission Issues**
```bash
# Run container as root (temporary fix)
docker run -u root ...

# Better: Fix permissions on host
chmod -R 777 ./data

# Best: Match user IDs
docker run -u $(id -u):$(id -g) ...
```

**Docker Socket Permission**
```bash
# Add user to docker group (Linux)
sudo usermod -aG docker $USER

# Restart shell
newgrp docker
```

---

### 7. Out of Disk Space

#### Symptoms
- "no space left on device"
- Build fails with disk space error

#### Diagnosis
```bash
# Check Docker disk usage
docker system df

# Check host disk space
df -h
```

#### Solutions

**Clean Up Docker Resources**
```bash
# Remove unused containers
docker container prune -f

# Remove unused images
docker image prune -a -f

# Remove unused volumes
docker volume prune -f

# Remove everything
docker system prune -a --volumes -f
```

**Increase Docker Disk Space**
```
Docker Desktop > Settings > Resources > Disk image size
```

---

### 8. Container Keeps Restarting

#### Symptoms
- Container status shows "Restarting"
- Container exits and restarts repeatedly

#### Diagnosis
```bash
# Check restart policy
docker inspect <container-name> | grep RestartPolicy -A 3

# View logs
docker logs --tail 100 <container-name>
```

#### Solutions

**Application Crashes**
```bash
# Check logs for errors
docker logs <container-name>

# Run without restart policy to debug
docker run -d --restart no ...
```

**Health Check Failing**
```bash
# Check health status
docker inspect --format='{{.State.Health.Status}}' <container-name>

# View health check logs
docker inspect --format='{{json .State.Health}}' <container-name>

# Disable health check temporarily
# Comment out HEALTHCHECK in Dockerfile
```

---

### 9. Slow Performance

#### Symptoms
- Container responds slowly
- High CPU or memory usage

#### Diagnosis
```bash
# Check resource usage
docker stats <container-name>

# Check container processes
docker exec <container-name> top
```

#### Solutions

**Resource Limits Too Low**
```bash
# Increase limits
docker run --memory="512m" --cpus="1.0" ...
```

**Too Many Containers**
```bash
# Check all running containers
docker ps

# Stop unnecessary containers
docker stop <container-name>
```

**Application Issues**
```bash
# Check application logs
docker logs <container-name>

# Profile application
docker exec <container-name> python -m cProfile app.py
```

---

### 10. Image Pull/Push Issues

#### Symptoms
- Cannot pull image from registry
- Cannot push image to registry

#### Solutions

**Authentication Required**
```bash
# Login to Docker Hub
docker login

# Login to private registry
docker login <registry-url>
```

**Network Issues**
```bash
# Use different DNS
docker pull --dns 8.8.8.8 <image>

# Check proxy settings
docker info | grep Proxy
```

**Rate Limiting**
```bash
# Docker Hub rate limits
# Solution: Login to increase limits
docker login

# Or use alternative registry
```

---

## Debugging Workflow

### Step 1: Identify the Problem
```bash
# Is container running?
docker ps -a

# Check logs
docker logs <container-name>

# Check resource usage
docker stats <container-name>
```

### Step 2: Gather Information
```bash
# Inspect container
docker inspect <container-name>

# Check events
docker events --since 10m

# System info
docker info
```

### Step 3: Test Hypothesis
```bash
# Access container
docker exec -it <container-name> /bin/bash

# Test network
docker exec <container-name> ping google.com

# Test application
docker exec <container-name> curl http://localhost:5000
```

### Step 4: Fix and Verify
```bash
# Apply fix
# ...

# Restart container
docker restart <container-name>

# Verify fix
curl http://localhost:8080
docker logs <container-name>
```

---

## Useful Debugging Commands

```bash
# View all container details
docker inspect <container-name> | less

# Follow logs in real-time
docker logs -f <container-name>

# Check container processes
docker top <container-name>

# View container filesystem changes
docker diff <container-name>

# Export container filesystem
docker export <container-name> > container.tar

# Check container resource usage
docker stats --no-stream <container-name>

# View container events
docker events --filter container=<container-name>
```

---

## Prevention Best Practices

1. **Always check logs first**
   ```bash
   docker logs <container-name>
   ```

2. **Use health checks**
   ```dockerfile
   HEALTHCHECK CMD curl -f http://localhost:5000/health || exit 1
   ```

3. **Set resource limits**
   ```bash
   docker run --memory="256m" --cpus="0.5" ...
   ```

4. **Use specific image tags**
   ```dockerfile
   FROM python:3.11-slim  # Not just 'python'
   ```

5. **Clean up regularly**
   ```bash
   docker system prune -f
   ```

6. **Monitor disk usage**
   ```bash
   docker system df
   ```

7. **Use .dockerignore**
   ```
   # Exclude unnecessary files
   *.log
   .git
   data/
   ```

8. **Test locally first**
   ```bash
   python app.py  # Before containerizing
   ```

---

## Getting Help

### Docker Documentation
- [Docker Docs](https://docs.docker.com/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)

### Community Resources
- [Docker Forums](https://forums.docker.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)
- [Docker Slack](https://dockercommunity.slack.com/)

### Diagnostic Tools
```bash
# Docker version
docker version

# Docker info
docker info

# System diagnostics
docker system info
```

---

**Remember**: Most Docker issues can be resolved by checking logs and inspecting container configuration! 🔍
