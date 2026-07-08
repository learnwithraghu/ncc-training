# Docker Containerization - Lab Challenge

## 🎯 Objective

Demonstrate your understanding of Docker containerization by building, running, and managing a Python Flask application in Docker containers.

---

## 📋 Prerequisites

- Docker installed and running
- Basic command-line knowledge
- Text editor (VS Code, vim, nano, etc.)

---

## 🚀 Challenge Tasks

### Task 1: Build the Docker Image (15 minutes)

**Goal**: Build a Docker image from the provided Dockerfile.

**Instructions**:

1. Navigate to the project directory:
   ```bash
   cd "Docker Containerization"
   ```

2. Review the application files:
   ```bash
   ls -la
   cat app.py
   cat Dockerfile
   cat requirements.txt
   ```

3. Build the Docker image:
   ```bash
   docker build -t hello-python-app:v1 .
   ```

4. Verify the image was created:
   ```bash
   docker images | grep hello-python-app
   ```

**Expected Output**:
```
hello-python-app   v1      <image-id>   X seconds ago   XXX MB
```

**Verification Questions**:
- What is the base image used in the Dockerfile?
- What port does the application expose?
- How many layers does the image have?

---

### Task 2: Run and Test the Container (10 minutes)

**Goal**: Run the container and verify the application is working.

**Instructions**:

1. Run the container:
   ```bash
   docker run -d -p 8080:5000 --name my-python-app hello-python-app:v1
   ```

2. Verify the container is running:
   ```bash
   docker ps
   ```

3. Test all endpoints:
   ```bash
   # Main endpoint
   curl http://localhost:8080/
   
   # Health check
   curl http://localhost:8080/health
   
   # Container info
   curl http://localhost:8080/info
   ```

4. Make multiple requests and observe the visit counter:
   ```bash
   curl http://localhost:8080/
   curl http://localhost:8080/
   curl http://localhost:8080/
   ```

**Expected Behavior**:
- Container should be in "Up" status
- All endpoints should return JSON responses
- Visit counter should increment with each request

**Verification Questions**:
- What is the container ID?
- What happens to the visit counter if you restart the container?

---

### Task 3: Implement Volume for Data Persistence (15 minutes)

**Goal**: Add a volume to persist data across container restarts.

**Instructions**:

1. Stop and remove the current container:
   ```bash
   docker stop my-python-app
   docker rm my-python-app
   ```

2. Create a named volume:
   ```bash
   docker volume create app-data
   docker volume ls
   docker volume inspect app-data
   ```

3. Run container with the volume mounted:
   ```bash
   docker run -d \
     -p 8080:5000 \
     --name my-python-app \
     -v app-data:/app/data \
     hello-python-app:v1
   ```

4. Write data to the volume:
   ```bash
   curl -X POST http://localhost:8080/write \
     -H "Content-Type: application/json" \
     -d '{"message": "First message"}'
   
   curl -X POST http://localhost:8080/write \
     -H "Content-Type: application/json" \
     -d '{"message": "Second message"}'
   
   curl -X POST http://localhost:8080/write \
     -H "Content-Type: application/json" \
     -d '{"message": "Third message"}'
   ```

5. Read the data:
   ```bash
   curl http://localhost:8080/read
   ```

6. Test persistence - restart the container:
   ```bash
   docker restart my-python-app
   
   # Wait a few seconds for container to start
   sleep 5
   
   # Read data again
   curl http://localhost:8080/read
   ```

7. Test persistence - create new container with same volume:
   ```bash
   docker stop my-python-app
   docker rm my-python-app
   
   docker run -d \
     -p 8080:5000 \
     --name my-python-app-v2 \
     -v app-data:/app/data \
     hello-python-app:v1
   
   # Data should still be there
   curl http://localhost:8080/read
   ```

**Expected Behavior**:
- Data persists after container restart
- Data persists even with a new container using the same volume

**Verification Questions**:
- Where is the volume data stored on the host?
- What's the difference between named volumes and bind mounts?

---

### Task 4: Create Custom Network (10 minutes)

**Goal**: Create a custom Docker network and run containers on it.

**Instructions**:

1. List existing networks:
   ```bash
   docker network ls
   ```

2. Create a custom bridge network:
   ```bash
   docker network create my-app-network
   ```

3. Inspect the network:
   ```bash
   docker network inspect my-app-network
   ```

4. Stop and remove existing container:
   ```bash
   docker stop my-python-app-v2
   docker rm my-python-app-v2
   ```

5. Run container on the custom network:
   ```bash
   docker run -d \
     --name my-python-app \
     --network my-app-network \
     -p 8080:5000 \
     -v app-data:/app/data \
     hello-python-app:v1
   ```

6. Run a second container on the same network:
   ```bash
   docker run -d \
     --name my-python-app-2 \
     --network my-app-network \
     hello-python-app:v1
   ```

7. Test container-to-container communication:
   ```bash
   # From second container, access first container by name
   docker exec my-python-app-2 curl http://my-python-app:5000/
   
   # From first container, access second container by name
   docker exec my-python-app curl http://my-python-app-2:5000/
   ```

8. View network details:
   ```bash
   docker network inspect my-app-network
   ```

**Expected Behavior**:
- Containers can communicate using container names
- Both containers appear in network inspection

**Verification Questions**:
- What is the subnet of your custom network?
- How does DNS resolution work in custom networks?

---

### Task 5: Monitor Logs (10 minutes)

**Goal**: View and monitor container logs effectively.

**Instructions**:

1. View all logs from the main container:
   ```bash
   docker logs my-python-app
   ```

2. View last 20 lines:
   ```bash
   docker logs --tail 20 my-python-app
   ```

3. Follow logs in real-time (open in a separate terminal):
   ```bash
   docker logs -f my-python-app
   ```

4. In another terminal, generate traffic:
   ```bash
   # Make several requests
   for i in {1..10}; do
     curl http://localhost:8080/
     sleep 1
   done
   ```

5. View logs with timestamps:
   ```bash
   docker logs -t my-python-app
   ```

6. View logs from last 5 minutes:
   ```bash
   docker logs --since 5m my-python-app
   ```

7. View logs between specific times:
   ```bash
   docker logs --since 2025-12-08T12:00:00 --until 2025-12-08T13:00:00 my-python-app
   ```

**Expected Behavior**:
- Logs show application startup messages
- Logs show incoming HTTP requests
- Real-time logs update as requests come in

**Verification Questions**:
- Where are Docker logs stored on the host?
- What's the default log driver?

---

### Task 6: Access Container Interactively (10 minutes)

**Goal**: Access running containers for debugging and exploration.

**Instructions**:

1. Execute single commands:
   ```bash
   # List files in /app
   docker exec my-python-app ls -la /app
   
   # Check Python version
   docker exec my-python-app python --version
   
   # View environment variables
   docker exec my-python-app env
   
   # Check running processes
   docker exec my-python-app ps aux
   ```

2. Open interactive shell:
   ```bash
   docker exec -it my-python-app /bin/bash
   ```

3. Inside the container, explore:
   ```bash
   # Navigate to app directory
   cd /app
   
   # List files
   ls -la
   
   # View application code
   cat app.py
   
   # Check data directory
   ls -la /app/data
   cat /app/data/messages.txt
   
   # Test application locally
   curl http://localhost:5000/
   
   # Check network configuration
   hostname
   hostname -i
   
   # View installed packages
   pip list
   
   # Exit container
   exit
   ```

4. Copy files between host and container:
   ```bash
   # Copy file from container to host
   docker cp my-python-app:/app/app.py ./app-backup.py
   
   # Verify file was copied
   ls -la app-backup.py
   
   # Copy file from host to container
   echo "Test config" > test-config.txt
   docker cp test-config.txt my-python-app:/app/
   
   # Verify file in container
   docker exec my-python-app ls -la /app/test-config.txt
   ```

**Expected Behavior**:
- Can execute commands inside container
- Can access interactive shell
- Can copy files to/from container

**Verification Questions**:
- What's the difference between `docker exec` and `docker attach`?
- Can you modify files inside a running container?

---

### Task 7: Complete Cleanup (10 minutes)

**Goal**: Properly clean up all Docker resources.

**Instructions**:

1. Check current resource usage:
   ```bash
   docker system df
   ```

2. List all containers:
   ```bash
   docker ps -a
   ```

3. Stop all running containers:
   ```bash
   docker stop my-python-app my-python-app-2
   ```

4. Remove all containers:
   ```bash
   docker rm my-python-app my-python-app-2
   ```

5. List and remove images:
   ```bash
   docker images
   docker rmi hello-python-app:v1
   ```

6. List and remove volumes:
   ```bash
   docker volume ls
   docker volume rm app-data
   ```

7. List and remove networks:
   ```bash
   docker network ls
   docker network rm my-app-network
   ```

8. Verify cleanup:
   ```bash
   docker ps -a
   docker images
   docker volume ls
   docker network ls
   ```

9. Check disk space reclaimed:
   ```bash
   docker system df
   ```

**Alternative: Complete cleanup in one command**:
```bash
# WARNING: This removes ALL unused resources
docker system prune -a --volumes -f
```

**Expected Behavior**:
- All containers removed
- All custom images removed
- All volumes removed
- All custom networks removed
- Disk space reclaimed

**Verification Questions**:
- What's the difference between `docker system prune` and `docker system prune -a`?
- Why is cleanup important?

---

## 🎓 Bonus Challenges

### Bonus 1: Multi-Container Setup

Run two instances of the app on different ports:

```bash
docker run -d -p 8080:5000 --name app-1 hello-python-app:v1
docker run -d -p 8081:5000 --name app-2 hello-python-app:v1

# Test both
curl http://localhost:8080/
curl http://localhost:8081/
```

### Bonus 2: Environment Variables

Run container with custom environment variables:

```bash
docker run -d \
  -p 8080:5000 \
  --name my-python-app \
  -e ENVIRONMENT=development \
  -e APP_VERSION=2.0 \
  hello-python-app:v1

# Check the environment
curl http://localhost:8080/info
```

### Bonus 3: Resource Limits

Run container with CPU and memory limits:

```bash
docker run -d \
  -p 8080:5000 \
  --name my-python-app \
  --memory="256m" \
  --cpus="0.5" \
  hello-python-app:v1

# Check resource usage
docker stats my-python-app
```

### Bonus 4: Health Check

Monitor container health:

```bash
docker run -d -p 8080:5000 --name my-python-app hello-python-app:v1

# Wait for health check
sleep 10

# Check health status
docker inspect --format='{{.State.Health.Status}}' my-python-app

# View health check logs
docker inspect --format='{{json .State.Health}}' my-python-app | python -m json.tool
```

---

## ✅ Completion Checklist

Mark each task as you complete it:

- [ ] Task 1: Built Docker image successfully
- [ ] Task 2: Ran and tested container
- [ ] Task 3: Implemented volume for persistence
- [ ] Task 4: Created custom network
- [ ] Task 5: Monitored logs effectively
- [ ] Task 6: Accessed container interactively
- [ ] Task 7: Cleaned up all resources

**Bonus Tasks**:
- [ ] Bonus 1: Multi-container setup
- [ ] Bonus 2: Environment variables
- [ ] Bonus 3: Resource limits
- [ ] Bonus 4: Health check monitoring

---

## 📊 Self-Assessment

Rate your understanding (1-5):

- [ ] Docker image building: ___/5
- [ ] Container lifecycle management: ___/5
- [ ] Volume management: ___/5
- [ ] Networking concepts: ___/5
- [ ] Log monitoring: ___/5
- [ ] Container access and debugging: ___/5
- [ ] Resource cleanup: ___/5

---

## 🎯 Key Concepts to Remember

1. **Images vs Containers**: Images are templates, containers are running instances
2. **Volumes**: Enable data persistence beyond container lifecycle
3. **Networks**: Allow container-to-container communication
4. **Logs**: Essential for debugging and monitoring
5. **Interactive Access**: Useful for troubleshooting
6. **Cleanup**: Prevents resource waste

---

## 📝 Lab Report Template

Document your experience:

```markdown
# Docker Lab Report

## Student Name: _______________
## Date: _______________

### Task 1: Build Image
- Build time: _______
- Image size: _______
- Issues encountered: _______

### Task 2: Run Container
- Container ID: _______
- Port mapping: _______
- Issues encountered: _______

### Task 3: Volumes
- Volume name: _______
- Data persisted: Yes/No
- Issues encountered: _______

### Task 4: Networking
- Network name: _______
- Subnet: _______
- Issues encountered: _______

### Task 5: Logs
- Log entries found: _______
- Issues encountered: _______

### Task 6: Container Access
- Commands executed: _______
- Files explored: _______
- Issues encountered: _______

### Task 7: Cleanup
- Resources removed: _______
- Disk space reclaimed: _______
- Issues encountered: _______

### Overall Experience
- Difficulty level (1-10): _______
- Time taken: _______
- Key learnings: _______
- Questions: _______
```

---

## 🆘 Need Help?

### Common Issues

**Issue**: Port already in use
```bash
# Solution: Use a different port
docker run -p 8081:5000 ...
```

**Issue**: Container won't start
```bash
# Solution: Check logs
docker logs <container-name>
```

**Issue**: Can't access application
```bash
# Solution: Verify port mapping
docker port <container-name>
```

**Issue**: Volume data not persisting
```bash
# Solution: Verify volume mount
docker inspect <container-name> | grep Mounts -A 10
```

---

**Good luck with your lab! 🚀**
