# Topic 16: Multi-Stage Builds

**Time:** 20 minutes

## Goal
Understand how multi-stage builds reduce image size and attack surface.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:multi-stage .
docker history ncc-training-app:multi-stage
```

## Guided Steps
1. Explain the difference between build and runtime stages.
2. Show how the final image can be smaller.
3. Discuss copying only the artifacts you need.
4. Inspect image history.
5. Explain why this matters for production deployments.

## Checkpoint
What is the main advantage of a multi-stage build?
