# Docker Best Practices for Production

## Introduction

Moving from development to production requires adopting practices that ensure security, performance, and maintainability. This guide covers essential Docker best practices for DevOps teams deploying containerized applications.

## Dockerfile Best Practices

### Use Official Base Images

```dockerfile
# ✅ Good - official, maintained image
FROM python:3.11-slim

# ❌ Bad - unknown source, potential security risks
FROM randomuser/python-custom
```

**Why:**
- Security updates from trusted sources
- Well-documented and tested
- Community support
- Regular vulnerability patches

### Minimize Image Size

**Use slim/alpine variants:**
```dockerfile
# Standard python image: ~900MB
FROM python:3.11

# Slim variant: ~120MB
FROM python:3.11-slim

# Alpine variant: ~50MB
FROM python:3.11-alpine
```

**Note:** Alpine uses `musl` instead of `glibc`, which can cause compatibility issues with some Python packages. Start with `slim` for Python applications.

### Layer Caching Optimization

```dockerfile
# ❌ Bad - Re-installs all dependencies when code changes
FROM python:3.11-slim
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

# ✅ Good - Caches dependencies separately
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
```

**Principle:** Order instructions from least to most frequently changing.

### Multi-Stage Builds

Reduce final image size by separating build and runtime:

```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-slim
WORKDIR /app

# Copy only production dependencies
COPY package*.json ./
RUN npm ci --production && npm cache clean --force

# Copy built artifacts from builder stage
COPY --from=builder /app/dist ./dist

USER node
CMD ["node", "dist/server.js"]
```

**Benefits:**
- Final image doesn't include npm build tools
- Smaller deployment size
- Reduced attack surface

### Run as Non-Root User

```dockerfile
FROM python:3.11-slim

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set up application
WORKDIR /app
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

CMD ["python", "app.py"]
```

**Why:** Root compromise in container = root on host (in many configurations)

### Use .dockerignore

```
# .dockerignore
.git
.gitignore
README.md
*.md
.env
.venv
venv/
__pycache__/
*.pyc
.pytest_cache/
.coverage
node_modules/
npm-debug.log
.DS_Store
.idea/
.vscode/
```

**Benefits:**
- Faster build times
- Smaller context size
- Prevents accidentally copying secrets

### Explicit Versions

```dockerfile
# ❌ Bad - version can change unexpectedly
FROM python:3

# ✅ Good - explicit and reproducible
FROM python:3.11.5-slim-bullseye
```

### Copy Only What's Needed

```dockerfile
# ❌ Bad - copies everything
COPY . .

# ✅ Good - selective copying
COPY src/ ./src/
COPY requirements.txt .
COPY entrypoint.sh .
```

## Security Best Practices

### Scan Images for Vulnerabilities

**Using Trivy:**
```bash
# Scan image
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image myapp:latest

# Fail build if critical vulnerabilities found
trivy image --severity CRITICAL,HIGH --exit-code 1 myapp:latest
```

**Using Docker Scout:**
```bash
docker scout cves myapp:latest
```

**Integrate into CI/CD:**
```yaml
# GitHub Actions
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'myapp:latest'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'
```

### Never Store Secrets in Images

```dockerfile
# ❌ NEVER do this
ENV DATABASE_PASSWORD=secretpass
ENV API_KEY=abc123xyz

# ❌ NEVER do this either
COPY .env .
```

**Secret checking found during build History:**
```bash
docker history myapp:latest
# All layers and ENVs are visible!
```

**✅ Proper Secret Management:**

**Option 1: Environment Variables at Runtime**
```bash
docker run -e DATABASE_PASSWORD=$DB_PASS myapp
```

**Option 2: Docker Secrets (Swarm)**
```bash
echo "secret-value" | docker secret create db_password -
docker service create --secret db_password myapp
```

**Option 3: Kubernetes Secrets**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  db_password: base64-encoded-pass
```

**Option 4: Cloud Secret Managers**
- AWS Secrets Manager
- Google Secret Manager
- Azure Key Vault
- HashiCorp Vault

### Limit Container Resources

```bash
# Memory limit
docker run --memory=512m --memory-reservation=256m myapp

# CPU limits
docker run --cpus=0.5 myapp

# Both
docker run --memory=1g --cpus=1.0 myapp
```

**In Dockerfile (documentation only):**
```dockerfile
LABEL resource.memory="512m"
LABEL resource.cpu="0.5"
```

**In Docker Compose:**
```yaml
services:
  web:
    image: myapp
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          memory: 256M
```

### Read-Only Root Filesystem

```bash
docker run --read-only -v /tmp:/tmp myapp
```

Forces immutability; any writes fail except to mounted volumes.

### Drop Capabilities

```bash
# Drop all, add only needed
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp
```

Common caps to drop:
- `CHOWN`
- `DAC_OVERRIDE`
- `FSETID`
- `FOWNER`

## Performance Optimization

### Leverage Build Cache

```dockerfile
# Install system dependencies (changes rarely)
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
  && rm -rf /var/lib/apt/lists/*

# Install app dependencies (changes occasionally)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code (changes frequently)
COPY . .
```

### Combine RUN Commands

```dockerfile
# ❌ Bad - creates many layers
RUN apt-get update
RUN apt-get install -y package1
RUN apt-get install -y package2
RUN apt-get clean

# ✅ Good - single layer
RUN apt-get update && \
    apt-get install -y \
      package1 \
      package2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### Use BuildKit

```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1
docker build -t myapp .

# Or inline
DOCKER_BUILDKIT=1 docker build -t myapp .
```

**BuildKit Benefits:**
- Parallel build stages
- Better caching
- Secrets support during build
- SSH forwarding for private repos

### Pin Dependency Versions

```txt
# requirements.txt
flask==2.3.2
requests==2.31.0
redis==4.6.0
```

**Why:** Reproducible builds, no surprise breaking changes

## Logging Best Practices

### Log to STDOUT/STDERR

```python
# ✅ Good - Docker captures this
import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

logger.info("Application started")
```

```dockerfile
# Don't write to files, use streams
CMD ["python", "-u", "app.py"]  # -u for unbuffered output
```

### Structured Logging

```python
import json
import logging

class JSONFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "message": record.getMessage(),
            "module": record.module
        })

handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logging.root.addHandler(handler)
```

**Benefits:** Easy parsing by log aggregators (ELK, Datadog, etc.)

### Log Rotation

```bash
# Limit log size
docker run --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  myapp
```

## Health Checks

### Dockerfile HEALTHCHECK

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1
```

**Without curl in image:**
```dockerfile
# Python example
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"
```

### Application Health Endpoint

```python
@app.route('/health')
def health():
    # Check dependencies
    try:
        db.ping()
        redis.ping()
        return {"status": "healthy"}, 200
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}, 503
```

## Network Security

### Use Custom Networks

```bash
# Create isolated network
docker network create --driver bridge app-network

# Run containers on custom network
docker run --network app-network --name db postgres
docker run --network app-network --name api myapp
```

**Benefits:**
- Containers isolated from default bridge
- DNS resolution by container name
- Controlled inter-container communication

### Network Segmentation

```bash
# Frontend network
docker network create frontend

# Backend network
docker network create backend

# API gateway bridges both
docker run --network frontend --network backend api-gateway
docker run --network frontend web-app
docker run --network backend database
```

Web app can't directly reach database.

## CI/CD Integration Patterns

### Build Once, Deploy Everywhere

```yaml
# .gitlab-ci.yml
build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest

deploy_staging:
  stage: deploy
  script:
    - docker pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:staging
    - deploy_to_staging.sh

deploy_production:
  stage: deploy
  when: manual
  script:
    - docker pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:production
    - deploy_to_production.sh
```

### Semantic Versioning for Tags

```bash
# Build with multiple tags
docker build -t myapp:1.2.3 -t myapp:1.2 -t myapp:1 -t myapp:latest .
docker push --all-tags myapp
```

### Testing in CI

```yaml
test:
  stage: test
  script:
    - docker build -t myapp-test .
    - docker run --rm myapp-test npm test
    - docker run --rm myapp-test npm run lint
```

## Monitoring and Observability

### Prometheus Metrics

```python
from prometheus_client import Counter, Histogram, generate_latest

REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests')
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency')

@app.route('/metrics')
def metrics():
    return generate_latest()
```

```dockerfile
EXPOSE 5000
EXPOSE 9090  # Metrics port
```

### Container Labels

```dockerfile
LABEL maintainer="devops@company.com"
LABEL version="1.2.3"
LABEL environment="production"
LABEL app="myapp"
```

Query containers by label:
```bash
docker ps --filter "label=app=myapp"
```

## Deployment Patterns

### Rolling Updates

```bash
# Update service gradually (Docker Swarm)
docker service update --image myapp:v2 myapp-service
```

### Blue-Green Deployment

```bash
# Deploy new version (green)
docker run -d --name app-green -p 8081:5000 myapp:v2

# Test green
curl http://localhost:8081/health

# Switch load balancer to green
update_loadbalancer.sh green

# Remove blue
docker stop app-blue && docker rm app-blue
```

### Canary Deployment

```bash
# 90% old version, 10% new version
docker service update --image myapp:v2 --replicas 1 myapp-service  # 1 of 10
# Monitor metrics
# If stable, roll out fully
docker service update --image myapp:v2 myapp-service
```

## Resource Cleanup

### Prune Regularly

```bash
# Remove stopped containers
docker container prune -f

# Remove unused images
docker image prune -a -f

# Remove unused volumes
docker volume prune -f

# Remove everything unused
docker system prune -a --volumes -f
```

### Automated Cleanup Script

```bash
#!/bin/bash
# cleanup.sh

# Remove containers stopped > 24 hours ago
docker container prune --filter "until=24h" -f

# Remove images without tags
docker image prune -f

# Remove volumes not used by any container
docker volume prune -f

# Show disk usage
docker system df
```

**Run in crontab:**
```
0 2 * * * /path/to/cleanup.sh
```

## Common Anti-Patterns to Avoid

### ❌ Running Multiple Processes in One Container

```dockerfile
# ❌ Bad
CMD supervisord -c /etc/supervisor/supervisord.conf
```

**Why:** One container = one process. use orchestration for multi-process apps.

### ❌ Using `latest` Tag in Production

```bash
# ❌ Bad - version ambiguous
docker pull myapp:latest
```

**Use specific versions:**
```bash
# ✅ Good
docker pull myapp:1.2.3
```

### ❌ Storing Data in Containers

```dockerfile
# ❌ Bad - data lost when container stops
RUN mkdir /var/data
```

**Use volumes or external storage.**

### ❌ Installing Unnecessary Packages

```dockerfile
# ❌ Bad - includes sudo, unnecessary in container
RUN apt-get install -y sudo vim curl wget ...
```

**Install only what your app needs.**

## Checklist for Production-Ready Dockerfiles

- [ ] Uses official base image with specific version
- [ ] Runs as non-root user
- [ ] Minimal image size (slim/alpine variant)
- [ ] Multi-stage build for compiled languages
- [ ] Layer caching optimized
- [ ] No secrets in image
- [ ] .dockerignore file present
- [ ] HEALTHCHECK defined
- [ ] Only necessary ports exposed
- [ ] Container scanned for vulnerabilities
- [ ] Resource limits documented
- [ ] Proper logging to STDOUT/STDERR

## Conclusion

Docker best practices ensure your containers are:
- **Secure**: Minimal attack surface, no secrets, scanned for vulnerabilities
- **Performant**: Optimized layers, minimal size, efficient caching
- **Reliable**: Health checks, proper logging, reproducible builds
- **Maintainable**: Clear documentation, semantic versioning, automated cleanup

Adopt these practices gradually. Start with security fundamentals (non-root user, secret management, scanning), then optimize for performance (multi-stage builds, caching), and finally implement operational excellence (health checks, monitoring, CI/CD integration).

Production-grade Docker isn't just about making containers run—it's about making them run securely, efficiently, and reliably at scale.
