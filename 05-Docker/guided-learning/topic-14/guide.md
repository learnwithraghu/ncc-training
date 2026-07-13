# Topic 14: Dockerfile Best Practices

**Time:** 20 minutes

## Goal
Apply common Dockerfile best practices to the sample app.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:best-practice .
```

## Guided Steps
1. Review the current Dockerfile.
2. Confirm the base image is official and minimal.
3. Explain why `requirements.txt` is copied early.
4. Talk about `.dockerignore`, version pinning, and selective copying.
5. Rebuild the image and compare build behavior.

## Checkpoint
Why is instruction order important in a Dockerfile?
